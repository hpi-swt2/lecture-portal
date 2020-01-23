import axios from 'axios';
import { createContext, useContext } from "react";
import {ComprehensionRootStoreModel} from "../stores/ComprehensionRootStore";
import {createComprehensionStore} from "../stores/createComprehensionStore";
import {setupComprehensionActionCable} from "./ComprehensionActionCable";

const StoreContext = createContext<ComprehensionRootStoreModel>(
    {} as ComprehensionRootStoreModel
);
export const useComprehensionStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

export interface IComprehensionAppProps {
    user_id: number,
    is_student: boolean,
    lecture_id: number,
    course_id: number,
    interactions_enabled: boolean,
    comprehension_state: any
}

const axiosInstance = axios.create();

export const formatDate = (date: Date): string => {
    if(date != null)
        return (date.getHours() < 10 ? "0" + date.getHours() : date.getHours())
            + ":"
            + (date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes());
    return "–";
};

const setupActionCable = (rootStore: ComprehensionRootStoreModel) => {
    setupComprehensionActionCable(rootStore.lecture_id,
        (comprehensionState) => {
            rootStore.setComprehensionState(comprehensionState)
        }
    );
};

export const createComprehensionRootStore = (): ComprehensionRootStoreModel => {
    return createComprehensionStore();
};

export const initComprehensionApp = (rootStore: ComprehensionRootStoreModel, params: IComprehensionAppProps) => {
    rootStore.setUserId(params.user_id);
    rootStore.setIsStudent(params.is_student);
    rootStore.setLectureId(params.lecture_id);
    rootStore.setInteractionsEnabled(params.interactions_enabled);
    rootStore.setCourseId(params.course_id);
    rootStore.setComprehensionState(params.comprehension_state);

    axiosInstance.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector<HTMLMetaElement>('[name=csrf-token]').content;
    axiosInstance.defaults.baseURL = `/courses/` + rootStore.course_id + `/lectures/` + rootStore.lecture_id + `/comprehension`;

    setupActionCable(rootStore);
};

export const updateComprehensionStamp = (status: number) => {
    axiosInstance.put("", { status: status })
};
