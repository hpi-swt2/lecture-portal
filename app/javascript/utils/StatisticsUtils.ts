import { createContext, useContext } from "react";
import { StatisticsRootStoreModel } from "../stores/StatisticsRootStore";
import { createStatisticsStore } from "../stores/createStatisticsStore";
import { setupQuestionsActionCable } from './QuestionsActionCable';
import {setupStudentsActionCable} from "./StudentsActionCable";

const StoreContext = createContext<StatisticsRootStoreModel>(
    {} as StatisticsRootStoreModel
);
export const useStatisticsStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const setupActionCable = (rootStore: StatisticsRootStoreModel) => {
    setupQuestionsActionCable(rootStore.lecture_id,
        () => { rootStore.increaseQuestionCount(); },
        () => { rootStore.increaseResolvedCount(); }
    );
    setupStudentsActionCable(rootStore.lecture_id,
        () => { rootStore.increaseStudentCount(); },
        () => { rootStore.decreaseStudentCount(); }
    );
};

export const createStatisticsRootStore = (): StatisticsRootStoreModel => {
    return createStatisticsStore();
};

export const initStatisticsApp = (rootStore: StatisticsRootStoreModel) => {
    setupActionCable(rootStore);
};
