import { createContext, useContext } from "react";
import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore";
import { HEADERS } from "./constants";
import {createQuestionsStore} from "../stores/createQuestionsStore";
import {setupQuestionsActionCable} from "./QuestionsActionCable";

const StoreContext = createContext<QuestionsRootStoreModel>(
  {} as QuestionsRootStoreModel
);
export const useQuestionsStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const getBaseRequestUrl = (courseId:number, lectureId: number): string => {
  return `/courses/` + courseId + `/lectures/` + lectureId + `/questions/`;
};

const loadQuestionsList = (rootStore: QuestionsRootStoreModel) => {
  fetch(getBaseRequestUrl(rootStore.course_id, rootStore.lecture_id))
    .then(res => res.json())
    .then(questions => {
      rootStore.questionsList.setQuestionsList(questions);
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

export const createQuestion = (content: string, courseId: number, lectureId: number) => {
  fetch(getBaseRequestUrl(courseId, lectureId), {
    method: "POST",
    headers: HEADERS,
    body: JSON.stringify({
      content: content
    })
  });
};

export const resolveQuestionById = (id: number, courseId: number, lectureId: number) => {
  fetch(getBaseRequestUrl(courseId, lectureId) + id + "/resolve", {
    method: "POST",
    headers: HEADERS
  });
};

export const upvoteQuestionById = (id, courseId, lectureId) => {
  fetch(getBaseRequestUrl(courseId, lectureId) + id + "/upvote", {
    method: "POST",
    headers: HEADERS
  });
};
