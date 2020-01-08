import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore"
import {UpdatesRootStoreModel} from "../stores/UpdatesRootStore";
import {PollsRootStoreModel} from "../stores/PollsRootStore";
import {useQuestionsStore} from "../utils/QuestionsUtils";
import {useUpdatesStore} from "../utils/UpdatesUtils";
import {usePollsStore} from "../utils/PollsUtils";

export type QuestionsMapStore<T> = (store: QuestionsRootStoreModel) => T
export type UpdatesMapStore<T> = (store: UpdatesRootStoreModel) => T
export type PollsMapStore<T> = (store: PollsRootStoreModel) => T

export const useInjectQuestions = <T>(mapStore: QuestionsMapStore<T>) => {
    const store = useQuestionsStore();
    return mapStore(store)
};
export const useInjectUpdates = <T>(mapStore: UpdatesMapStore<T>) => {
    const store = useUpdatesStore();
    return mapStore(store)
};
export const useInjectPolls = <T>(mapStore: PollsMapStore<T>) => {
    const store = usePollsStore();
    return mapStore(store)
};
