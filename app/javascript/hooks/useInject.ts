import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore"
import {UpdatesRootStoreModel} from "../stores/UpdatesRootStore";
import {useQuestionsStore} from "../utils/QuestionsUtils";
import {useUpdatesStore} from "../utils/UpdatesUtils";
import {ComprehensionRootStoreModel} from "../stores/ComprehensionRootStore";
import {useComprehensionStore} from "../utils/ComprehensionUtils";
import { PollOptionsRootStoreModel } from "../stores/PollOptionsRootStore"
import {usePollOptionsStore} from "../utils/PollOptionUtils";

export type QuestionsMapStore<T> = (store: QuestionsRootStoreModel) => T
export type UpdatesMapStore<T> = (store: UpdatesRootStoreModel) => T
export type ComprehensionMapStore<T> = (store: ComprehensionRootStoreModel) => T

export const useInjectQuestions = <T>(mapStore: QuestionsMapStore<T>) => {
    const store = useQuestionsStore();
    return mapStore(store)
};
export const useInjectUpdates = <T>(mapStore: UpdatesMapStore<T>) => {
    const store = useUpdatesStore();
    return mapStore(store)
};
export const useInjectComprehension = <T>(mapStore: ComprehensionMapStore<T>) => {
    const store = useComprehensionStore();
    return mapStore(store)
};

export type PollOptionsMapStore<T> = (store: PollOptionsRootStoreModel) => T

export const useInjectPollOptions = <T>(mapStore: PollOptionsMapStore<T>) => {
    const store = usePollOptionsStore();
    return mapStore(store)
};
