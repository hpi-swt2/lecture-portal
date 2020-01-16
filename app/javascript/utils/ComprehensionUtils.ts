import axios from 'axios';
import { createContext, useContext } from "react";
import {ComprehensionRootStoreModel} from "../stores/ComprehensionRootStore";
import {createComprehensionStore} from "../stores/createComprehensionStore";
import {setupComprehensionActionCable} from "./ComprehensionActionCable";

const StoreContext = createContext<ComprehensionRootStoreModel>(
  {} as ComprehensionRootStoreModel
);
export const useComprehensionStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const getBaseRequestUrl = (lectureId: number): string => {
  return `/lectures/` + lectureId + `/comprehension`;
};

export const formatDate = (date: Date): string => {
  if(date != null)
    return (date.getHours() < 10 ? "0" + date.getHours() : date.getHours())
      + ":"
      + (date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes());
  return "-";
};

const loadComprehensionState = (rootStore: ComprehensionRootStoreModel) => {
  axios.get(getBaseRequestUrl(rootStore.lecture_id))
    .then(res => {
      rootStore.setComprehensionState(res.data);
    });
};


const setupActionCable = (rootStore: ComprehensionRootStoreModel) => {
  setupComprehensionActionCable(rootStore.lecture_id,
      (comprehensionState) => {
        rootStore.setComprehensionState(comprehensionState)
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
    axios.put(getBaseRequestUrl(lectureId), { status: status })
};
