import {UpdatesRootStoreModel} from "../stores/UpdatesRootStore";
import {createUpdatesStore} from "../stores/createUpdatesStore";
import {setupQuestionsActionCable} from "./QuestionsActionCable";
import {createContext, useContext} from "react";
import axios from "axios";

const StoreContext = createContext<UpdatesRootStoreModel>(
    {} as UpdatesRootStoreModel
);
export const useUpdatesStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const axiosInstance = axios.create();

const loadQuestionsList = (rootStore: UpdatesRootStoreModel) => {
    axiosInstance.get("")
        .then(res => {
            rootStore.updatesList.setQuestionsList(res.data);
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
    axiosInstance.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector<HTMLMetaElement>('[name=csrf-token]').content;
    axiosInstance.defaults.baseURL = `/courses/` + rootStore.course_id + `/lectures/` + rootStore.lecture_id + `/questions/`;
    loadQuestionsList(rootStore);
    setupActionCable(rootStore);
};
