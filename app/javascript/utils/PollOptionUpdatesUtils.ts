import {UpdatePollOptionsRootStoreModel} from "../stores/UpdatePollOptionsRootStore";
import {createUpdatePollOptionsStore} from "../stores/createUpdatePollOptionsStore";
import {setupPollOptionsActionCable} from "./PollOptionsActionCable";
import {createContext, useContext} from "react";

const StoreContext = createContext<UpdatePollOptionsRootStoreModel>(
    {} as UpdatePollOptionsRootStoreModel
);
export const useUpdatePollOptionsStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const getBaseRequestUrl = (lectureId: number, pollId: number): string => {
    return `/lectures/` + lectureId + `/polls/` + pollId + `/`;
};

const loadPollOptions = (rootStore: UpdatePollOptionsRootStoreModel) => {
    const url: string = getBaseRequestUrl(rootStore.lecture_id, rootStore.poll_id) + `serialized_options`
    fetch(url)
        .then(res => res.json())
        .then(pollOptions => {
            rootStore.poll_options.setPollOptions(pollOptions);
        });
};

const setupActionCable = (rootStore: UpdatePollOptionsRootStoreModel) => {
    setupPollOptionsActionCable(rootStore.lecture_id,
        (poll_options) => {
            rootStore.poll_options.setPollOptions(poll_options);
        }
    );
};

export const createUpdatePollOptionsRootStore = (): UpdatePollOptionsRootStoreModel => {
    return createUpdatePollOptionsStore();
};

export const initUpdatePollOptionsApp = (rootStore: UpdatePollOptionsRootStoreModel) => {
    loadPollOptions(rootStore);
    setupActionCable(rootStore);
};
