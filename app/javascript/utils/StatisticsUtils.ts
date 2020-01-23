import { createContext, useContext } from "react";
import { StatisticsRootStoreModel } from "../stores/StatisticsRootStore";
import { createStatisticsStore } from "../stores/createStatisticsStore";
import { setupQuestionsActionCable } from './QuestionsActionCable';

const StoreContext = createContext<StatisticsRootStoreModel>(
    {} as StatisticsRootStoreModel
);
export const useStatisticsStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const setupActionCable = (rootStore: StatisticsRootStoreModel) => {
    setupQuestionsActionCable(rootStore.lecture_id,
        (data) => { rootStore.increaseQuestionCount(); },
        (id) => { rootStore.increaseResolvedCount(); },
        (question_id, upvoter_id) => { }
    );
};

export const createStatisticsRootStore = (): StatisticsRootStoreModel => {
    return createStatisticsStore();
};

export const initStatisticsApp = (rootStore: StatisticsRootStoreModel) => {
    setupActionCable(rootStore);
};
