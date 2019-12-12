import ActionCable from "actioncable";
import {createContext, useContext} from "react";
import {RootStoreModel} from "../stores/QuestionsRootStore";
import {createStore} from "../stores/createStore";
import {HEADERS} from "./constants";

const StoreContext = createContext<RootStoreModel>({} as RootStoreModel);
export const useStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const loadQuestionsList = (rootStore) => {
    fetch(`/api/questions`)
        .then(res => res.json())
        .then(questions => {
            rootStore.questionsList.setQuestionsList(questions);
        });
};

const CableApp = {
    cable: ActionCable.createConsumer(`/cable`)
};

const setupActionCable = (rootStore) => {
    CableApp.cable.subscriptions.create(
        {channel: "QuestionsChannel"},
        {
            received: data => {
                const {question} = data;
                rootStore.questionsList.addQuestion(question);
            }
        }
    );
    CableApp.cable.subscriptions.create(
        {channel: "QuestionResolvingChannel"},
        {
            received: id => {
                rootStore.questionsList.resolveQuestionById(id)
            }
        }
    );
};

const initQuestionsApp = () : RootStoreModel => {
    const rootStore = createStore();
    loadQuestionsList(rootStore);
    setupActionCable(rootStore);
    return rootStore;
};

export const createQuestion = (content) => {
    fetch(`/api/questions`, {
        method: "POST",
        headers: HEADERS,
        body: JSON.stringify({
            content: content
        })
    });
};

export const resolveQuestionById = (id) => {
    fetch(`/api/questions/` + id + '/resolve', {
        method: "POST",
        headers: HEADERS
    });
};

export default initQuestionsApp;
