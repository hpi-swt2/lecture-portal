import { createContext, useContext } from "react";
import { PollOptionsRootStoreModel } from "../stores/PollOptionsRootStore";
import {createPollOptionsStore} from "../stores/createPollOptionsStore";
import {setupPollOptionsActionCable} from "./PollOptionsActionCable";

const StoreContext = createContext<PollOptionsRootStoreModel>(
    {} as PollOptionsRootStoreModel
);
export const usePollOptionsStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const getBaseRequestUrl = (lectureId: number): string => {
    return `/lectures/` + lectureId + `/polls/`;
};

const loadPollOptions = (rootStore: PollOptionsRootStoreModel) => {
    fetch(getBaseRequestUrl(rootStore.lecture_id))
        .then(res => res.json())
        .then(questions => {
            rootStore.poll_options.setPollOptions(questions);
        });
};


const setupActionCable = (rootStore: PollOptionsRootStoreModel) => {
    setupPollOptionsActionCable(rootStore.lecture_id,
        (data) => {
            rootStore.poll_options.setPollOptions(data);
        }
    );
};

export const createPollOptionsRootStore = (): PollOptionsRootStoreModel => {
    return createPollOptionsStore();
};

export const initPollOptionsApp = (rootStore: PollOptionsRootStoreModel) => {
    loadPollOptions(rootStore);
    setupActionCable(rootStore);
};