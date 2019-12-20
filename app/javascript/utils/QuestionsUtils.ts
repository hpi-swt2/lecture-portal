import ActionCable from "actioncable";
import { createContext, useContext } from "react";
import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore";
import { createStore } from "../stores/createStore";
import { HEADERS } from "./constants";

const StoreContext = createContext<QuestionsRootStoreModel>({} as QuestionsRootStoreModel);
export const useStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const getBaseRequestUrl = (lectureId: number): string => {
    return `/lectures/` + lectureId + `/questions/`
};

const loadQuestionsList = (rootStore: QuestionsRootStoreModel) => {
    fetch(getBaseRequestUrl(rootStore.lecture_id))
        .then(res => res.json())
        .then(questions => {
            rootStore.questionsList.setQuestionsList(questions);
        });
};

const CableApp = {
    cable: ActionCable.createConsumer(`/cable`)
};

const setupActionCable = (rootStore: QuestionsRootStoreModel) => {
    CableApp.cable.subscriptions.create(
        { channel: "QuestionsChannel", lecture: rootStore.lecture_id },
        {
            received: data => {
                const { question } = data;
                rootStore.questionsList.addQuestion(question);
            }
        }
    );
    CableApp.cable.subscriptions.create(
        { channel: "QuestionResolvingChannel", lecture: rootStore.lecture_id },
        {
            received: id => {
                rootStore.questionsList.resolveQuestionById(id)
            }
        }
    );
    CableApp.cable.subscriptions.create(
        { channel: "QuestionUpvotingChannel", lecture: rootStore.lecture_id },
        {
            received: data => {
                rootStore.questionsList.upvoteQuestionById(data.question_id, data.upvoter_id);
            }
        }
    );
};

export const createQuestionsRootStore = (): QuestionsRootStoreModel => {
    return createStore();
};

export const initQuestionsApp = (rootStore: QuestionsRootStoreModel) => {
    loadQuestionsList(rootStore);
    setupActionCable(rootStore);
};

export const createQuestion = (content: string, lectureId: number) => {
    fetch(getBaseRequestUrl(lectureId), {
        method: "POST",
        headers: HEADERS,
        body: JSON.stringify({
            content: content
        })
    });
};

export const resolveQuestionById = (id: number, lectureId: number) => {
    fetch(getBaseRequestUrl(lectureId) + id + '/resolve', {
        method: "POST",
        headers: HEADERS
    });
};

export const upvoteQuestionById = (id, lectureId) => {
    fetch(getBaseRequestUrl(lectureId) + id + '/upvote', {
        method: "POST",
        headers: HEADERS
    });
};
