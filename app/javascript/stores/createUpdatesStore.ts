import UpdatesRootStore, {UpdatesRootStoreEnv, UpdatesRootStoreModel} from "./UpdatesRootStore";
import UpdatesList from "./UpdatesList";
import QuestionsList from "./QuestionsList";

export const createUpdatesStore = (): UpdatesRootStoreModel => {
    const updatesList = UpdatesList.create({
        questions-list: QuestionsList.create({
            list: []
        })
    });
    const env: UpdatesRootStoreEnv = {
        updatesList: updatesList
    };

    return UpdatesRootStore.create(
        {
            updatesList: updatesList
        },
        env
    )
};