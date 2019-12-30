import {UpdatePollOptionsRootStoreModel} from "../stores/UpdatePollOptionsRootStore";
import {createUpdatePollOptionsStore} from "../stores/createUpdatePollOptionsStore";
import {setupPollOptionsActionCable} from "./PollOptionsActionCable";
import {createContext, useContext} from "react";

const StoreContext = createContext<UpdatePollOptionsRootStoreModel>(
    {} as UpdatePollOptionsRootStoreModel
);
export const useUpdatePollOptionsStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const getBaseRequestUrl = (lectureId: number): string => {
    return `/lectures/` + lectureId + `/polls/`;
};

const loadPollOptions = (rootStore: UpdatePollOptionsRootStoreModel) => {
    fetch(getBaseRequestUrl(rootStore.lecture_id))
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
