import { useStore} from "../utils/QuestionsUtils";
import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore"

export type MapStore<T> = (store: QuestionsRootStoreModel) => T

const useInject = <T>(mapStore: MapStore<T>) => {
    const store = useStore();
    return mapStore(store)
};

export default useInject