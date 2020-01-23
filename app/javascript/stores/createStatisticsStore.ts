import StatisticsRootStore, { StatisticsRootStoreModel } from "./StatisticsRootStore";

export const createStatisticsStore = (): StatisticsRootStoreModel => {
    return StatisticsRootStore.create()
};