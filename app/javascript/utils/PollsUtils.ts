import { createContext, useContext } from "react";
import { PollsRootStoreModel } from "../stores/PollsRootStore";
import { HEADERS } from "./constants";
import {createPollsStore} from "../stores/createPollsStore";
import {setupPollsActionCable} from "./PollsActionCable";

const StoreContext = createContext<PollsRootStoreModel>(
  {} as PollsRootStoreModel
);
export const usePollsStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const getBaseRequestUrl = (lectureId: number): string => {
  console.log(lectureId);
  return `/lectures/` + lectureId + "/";
};

const loadPollsList = (rootStore: PollsRootStoreModel) => {
  fetch(getBaseRequestUrl(rootStore.id) + "get_all_serialized_polls")
    .then(res => res.json())
    .then(polls => {
      rootStore.pollsList.setPollsList(polls);
    });
};


const setupActionCable = (rootStore: PollsRootStoreModel) => {
  setupPollsActionCable(rootStore.id,
      (data) => {
        const { poll } = data;
        rootStore.pollsList.addPoll(data);
      }
  );
};

export const createPollsRootStore = (): PollsRootStoreModel => {
  return createPollsStore();
};

export const initPollsApp = (rootStore: PollsRootStoreModel) => {
  loadPollsList(rootStore);
  setupActionCable(rootStore);
};

export const createPoll = (content: string, lectureId: number) => {
  fetch(getBaseRequestUrl(lectureId), {
    method: "POST",
    headers: HEADERS,
    body: JSON.stringify({
      content: content
    })
  });
};

export const resolvePollById = (id: number, lectureId: number) => {
  fetch(getBaseRequestUrl(lectureId) + id + "/resolve", {
    method: "POST",
    headers: HEADERS
  });
};

export const upvotePollById = (id, lectureId) => {
  fetch(getBaseRequestUrl(lectureId) + id + "/upvote", {
    method: "POST",
    headers: HEADERS
  });
};
