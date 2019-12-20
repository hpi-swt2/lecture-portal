import {UpdatesRootStoreModel} from "../stores/UpdatesRootStore";
import {createUpdatesStore} from "../stores/createUpdatesStore";
import {setupQuestionsActionCable} from "./QuestionsActionCable";
import {createContext, useContext} from "react";

const StoreContext = createContext<UpdatesRootStoreModel>(
    {} as UpdatesRootStoreModel
);
export const useUpdatesStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const getBaseRequestUrl = (lectureId: number): string => {
    return `/lectures/` + lectureId + `/questions/`;
};

const loadQuestionsList = (rootStore: UpdatesRootStoreModel) => {
    fetch(getBaseRequestUrl(rootStore.lecture_id))
        .then(res => res.json())
        .then(questions => {
            rootStore.updatesList.setQuestionsList(questions);
        });
};

const setupActionCable = (rootStore: UpdatesRootStoreModel) => {
    setupQuestionsActionCable(rootStore.lecture_id,
        (data) => {
            const { question } = data;
            rootStore.updatesList.questionsList.addQuestion(question);
        }, (id) => {
            rootStore.updatesList.questionsList.resolveQuestionById(id);
        }, (question_id, upvoter_id) => {
            rootStore.updatesList.questionsList.upvoteQuestionById(
                question_id,
                upvoter_id
        )}
    );
};

export const createUpdatesRootStore = (): UpdatesRootStoreModel => {
    return createUpdatesStore();
};

export const initUpdatesApp = (rootStore: UpdatesRootStoreModel) => {
    loadQuestionsList(rootStore);
    setupActionCable(rootStore);
};
