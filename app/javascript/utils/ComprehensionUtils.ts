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

const axiosInstance = axios.create();

export const formatDate = (date: Date): string => {
    if(date != null)
        return (date.getHours() < 10 ? "0" + date.getHours() : date.getHours())
            + ":"
            + (date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes());
    return "–";
};

const loadComprehensionState = (rootStore: ComprehensionRootStoreModel) => {
    axiosInstance.get("")
        .then(res => {
            rootStore.setComprehensionState(res.data);
        });
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

export const initComprehensionApp = (rootStore: ComprehensionRootStoreModel) => {
    axiosInstance.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector<HTMLMetaElement>('[name=csrf-token]').content;
    axiosInstance.defaults.baseURL = `/lectures/` + rootStore.lecture_id + `/comprehension`;
    loadComprehensionState(rootStore);
    setupActionCable(rootStore);
};

export const updateComprehensionStamp = (status: number) => {
    axiosInstance.put("", { status: status })
};
