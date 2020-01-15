import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore"
import {UpdatesRootStoreModel} from "../stores/UpdatesRootStore";
import {useQuestionsStore} from "../utils/QuestionsUtils";
import {useUpdatesStore} from "../utils/UpdatesUtils";

export type QuestionsMapStore<T> = (store: QuestionsRootStoreModel) => T
export type UpdatesMapStore<T> = (store: UpdatesRootStoreModel) => T

export const useInjectQuestions = <T>(mapStore: QuestionsMapStore<T>) => {
    const store = useQuestionsStore();
    return mapStore(store)
};
export const useInjectUpdates = <T>(mapStore: UpdatesMapStore<T>) => {
    const store = useUpdatesStore();
    return mapStore(store)
};
