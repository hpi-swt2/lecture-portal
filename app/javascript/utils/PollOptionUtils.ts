import { createContext, useContext } from "react";
import { PollOptionsRootStoreModel } from "../stores/PollOptionsRootStore";
import {createPollOptionsStore} from "../stores/createPollOptionsStore";
import {setupPollOptionsActionCable} from "./PollOptionsActionCable";

const StoreContext = createContext<PollOptionsRootStoreModel>(
    {} as PollOptionsRootStoreModel
);
export const usePollOptionsStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const getBaseRequestUrl = (lectureId: number, pollId: number): string => {
    return `/lectures/` + lectureId + `/polls/` + pollId + `/`;
};

const loadPollOptions = (rootStore: PollOptionsRootStoreModel) => {
    const url: string = getBaseRequestUrl(rootStore.lecture_id, rootStore.poll_id) + `serialized_options`
    fetch(url)
        .then(res => res.json())
        .then(pollOptions => {
            rootStore.poll_options.setPollOptions(pollOptions);
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