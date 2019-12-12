import { useStore} from "../utils/QuestionsUtils";
import { RootStoreModel } from "../stores/QuestionsRootStore"

export type MapStore<T> = (store: RootStoreModel) => T

const useInject = <T>(mapStore: MapStore<T>) => {
    const store = useStore();
    return mapStore(store)
};

export default useInject