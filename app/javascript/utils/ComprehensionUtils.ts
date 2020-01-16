import { createContext, useContext } from "react";
import { HEADERS } from "./constants";
import {ComprehensionRootStoreModel} from "../stores/ComprehensionRootStore";
import {createComprehensionStore} from "../stores/createComprehensionStore";
import {setupComprehensionActionCable} from "./ComprehensionActionCable";

const StoreContext = createContext<ComprehensionRootStoreModel>(
  {} as ComprehensionRootStoreModel
);
export const useComprehensionStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const getBaseRequestUrl = (lectureId: number): string => {
  return `/lectures/` + lectureId + `/`;
};

export const formatDate = (date: Date): string => {
  if(date != null)
    return (date.getHours() < 10 ? "0" + date.getHours() : date.getHours())
      + ":"
      + (date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes());
  return "-";
};

const loadComprehensionState = (rootStore: ComprehensionRootStoreModel) => {
  fetch(getBaseRequestUrl(rootStore.lecture_id) + `comprehension`, {
    method: "GET"
  }).then(res => res.json())
    .then(comprehensionState => {
      console.log(comprehensionState);
      rootStore.setComprehensionState(comprehensionState);
    });
};


const setupActionCable = (rootStore: ComprehensionRootStoreModel) => {
  setupComprehensionActionCable(rootStore.lecture_id,
      (data) => {
        // TODO: use update data
        //const { question } = data;
        //rootStore.setActiveStamp(dsdsg)
      }
  );
};

export const createComprehensionRootStore = (): ComprehensionRootStoreModel => {
  return createComprehensionStore();
};

export const initComprehensionApp = (rootStore: ComprehensionRootStoreModel) => {
  loadComprehensionState(rootStore);
  setupActionCable(rootStore);
};

export const updateComprehensionStamp = (status: number, lectureId: number) => {
  fetch(getBaseRequestUrl(lectureId) + `updateComprehensionStamp`, {
    method: "POST",
    headers: HEADERS,
    body: JSON.stringify({
      status: status
    })
  });
};
