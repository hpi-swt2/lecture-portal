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

const getBaseRequestUrl = (lectureId: number): string => {
  return `/lectures/` + lectureId + `/questions/`;
};

const loadQuestionsList = (rootStore: QuestionsRootStoreModel) => {
  axios.get(getBaseRequestUrl(rootStore.lecture_id))
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
  loadQuestionsList(rootStore);
  setupActionCable(rootStore);
};

export const createQuestion = (content: string, lectureId: number) => {
  axios.post(getBaseRequestUrl(lectureId), { content: content });
};

export const resolveQuestionById = (id: number, lectureId: number) => {
  axios.post(getBaseRequestUrl(lectureId) + id + "/resolve");
};

export const upvoteQuestionById = (id, lectureId) => {
  axios.post(getBaseRequestUrl(lectureId) + id + "/upvote");
};
