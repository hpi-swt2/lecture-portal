import store from "./store";

export { default } from "./store";

export interface IStoreProps {
  store: typeof store.Type;
}
