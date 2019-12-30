import UpdatePollOptionsRootStore, {UpdatePollOptionsRootStoreEnv, UpdatePollOptionsRootStoreModel} from "./UpdatePollOptionsRootStore";
import UpdatePollOptions from "./UpdatePollOptions";
import PollOptions from "./PollOptions";

export const createUpdatePollOptionsStore = (): UpdatePollOptionsRootStoreModel => {
    const updatesList = UpdatePollOptions.create({
        poll_options: PollOptions.create({
            poll_options: []
        })
    });
    const env: UpdatePollOptionsRootStoreEnv = {
        poll_options: updatesList
    };

    return UpdatePollOptionsRootStore.create(
        {
            poll_options: updatesList
        },
        env
    )
};