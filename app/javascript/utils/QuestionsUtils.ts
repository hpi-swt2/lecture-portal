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

export interface IQuestionsAppProps {
    user_id: number,
    is_student: boolean,
    lecture_id: number,
    course_id: number,
    interactions_enabled: boolean,
    questions_list: any
}

const axiosInstance = axios.create();

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

export const initQuestionsApp = (rootStore: QuestionsRootStoreModel, params: IQuestionsAppProps) => {
    rootStore.setUserId(params.user_id);
    rootStore.setIsStudent(params.is_student);
    rootStore.setLectureId(params.lecture_id);
    rootStore.setCourseId(params.course_id);
    rootStore.setInteractionsEnabled(params.interactions_enabled);
    rootStore.questionsList.setQuestionsList(params.questions_list);

    axiosInstance.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector<HTMLMetaElement>('[name=csrf-token]').content;
    axiosInstance.defaults.baseURL = `/courses/` + rootStore.course_id + `/lectures/` + rootStore.lecture_id + `/questions/`;

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
