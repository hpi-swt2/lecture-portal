import axios from 'axios';
import { createContext, useContext } from "react";
import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore";
import {createQuestionsStore} from "../stores/createQuestionsStore";
import {setupQuestionsActionCable} from "./QuestionsActionCable";

const StoreContext = createContext<QuestionsRootStoreModel>(
  {} as QuestionsRootStoreModel
);
export const useQuestionsStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const axiosInstance = axios.create();

const loadQuestionsList = (rootStore: QuestionsRootStoreModel) => {
  axiosInstance.get("")
    .then(res => {
      rootStore.questionsList.setQuestionsList(res.data);
    });
};


const setupActionCable = (rootStore: QuestionsRootStoreModel) => {
  setupQuestionsActionCable(rootStore.lecture_id,
      (data) => {
        const { question } = data;
        rootStore.questionsList.addQuestion(question);
      }, (id) => {
        rootStore.questionsList.resolveQuestionById(id);
      }, (question_id, upvoter_id) => {
        rootStore.questionsList.upvoteQuestionById(
            question_id,
            upvoter_id
      )}
  );
};

export const createQuestionsRootStore = (): QuestionsRootStoreModel => {
  return createQuestionsStore();
};

export const initQuestionsApp = (rootStore: QuestionsRootStoreModel) => {
    axiosInstance.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector<HTMLMetaElement>('[name=csrf-token]').content;
    axiosInstance.defaults.baseURL = `/courses/` + rootStore.courseId + `/lectures/` + rootStore.lecture_id + `/questions/`;
    loadQuestionsList(rootStore);
    setupActionCable(rootStore);
};

export const createQuestion = (content: string) => {
    axiosInstance.post("", { content: content });
};

export const resolveQuestionById = (id: number) => {
    axiosInstance.post(id + "/resolve");
};

export const upvoteQuestionById = (id : number) => {
    axiosInstance.post(id + "/upvote");
};
