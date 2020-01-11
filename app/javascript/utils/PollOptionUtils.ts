import { createContext, useContext } from "react";
import { PollOptionsRootStoreModel } from "../stores/PollOptionsRootStore";
import {createPollOptionsStore} from "../stores/createPollOptionsStore";
import {setupPollOptionsActionCable} from "./PollOptionsActionCable";
import {setupPollParticipantsCountActionCable} from "./PollParticipantsCountActionCable";

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

const loadParticipantsCount = (rootStore: PollOptionsRootStoreModel) => {
    const url: string = getBaseRequestUrl(rootStore.lecture_id, rootStore.poll_id) + `serialized_participants_count`
    fetch(url)
        .then(res => res.json())
        .then(pollParticipants => {
            rootStore.poll_participants_count.setPollParticipants(pollParticipants);
        });
};


const setupActionCable = (rootStore: PollOptionsRootStoreModel) => {
    setupPollOptionsActionCable(rootStore.lecture_id,
        (data) => {
            rootStore.poll_options.setPollOptions(data);
        }
    );
};

const setupParticipantsActionCable = (rootStore: PollOptionsRootStoreModel) => {
    setupPollParticipantsCountActionCable(rootStore.lecture_id,
        (data) => {
            rootStore.poll_participants_count.setPollParticipants(data);
        }
    );
};

export const createPollOptionsRootStore = (): PollOptionsRootStoreModel => {
    return createPollOptionsStore();
};

export const initPollOptionsApp = (rootStore: PollOptionsRootStoreModel) => {
    loadPollOptions(rootStore);
    loadParticipantsCount(rootStore);
    setupActionCable(rootStore);
    setupParticipantsActionCable(rootStore);
};