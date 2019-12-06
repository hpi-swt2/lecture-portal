import { useStore } from "../components/QuestionsApp"
import { RootStoreModel } from "../stores/RootStore"

export type MapStore<T> = (store: RootStoreModel) => T

const useInject = <T>(mapStore: MapStore<T>) => {
    const store = useStore();
    return mapStore(store)
};

export default useInject