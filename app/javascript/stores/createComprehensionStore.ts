import ComprehensionRootStore, {ComprehensionRootStoreModel} from "./ComprehensionRootStore";

export const createComprehensionStore = (): ComprehensionRootStoreModel => {
    return ComprehensionRootStore.create()
};