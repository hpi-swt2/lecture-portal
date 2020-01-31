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

export interface IUpdatesAppProps {
    user_id: number,
    is_student: boolean,
    lecture_id: number,
    course_id: number,
    interactions_enabled: boolean,
    questions_list: any
}

const axiosInstance = axios.create();

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

export const initUpdatesApp = (rootStore: UpdatesRootStoreModel, params: IUpdatesAppProps) => {
    rootStore.setUserId(params.user_id);
    rootStore.setIsStudent(params.is_student);
    rootStore.setLectureId(params.lecture_id);
    rootStore.setInteractionsEnabled(params.interactions_enabled);
    rootStore.setCourseId(params.course_id);
    rootStore.updatesList.setQuestionsList(params.questions_list);

    axiosInstance.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector<HTMLMetaElement>('[name=csrf-token]').content;
    axiosInstance.defaults.baseURL = `/courses/` + rootStore.course_id + `/lectures/` + rootStore.lecture_id + `/questions/`;

    setupActionCable(rootStore);
};
