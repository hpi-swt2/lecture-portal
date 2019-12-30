import PollOptionsRootStore, { PollOptionsRootStoreEnv, PollOptionsRootStoreModel } from "./PollOptionsRootStore";
import PollOptions from "./PollOptions";

export const createPollOptionsStore = (): PollOptionsRootStoreModel => {
    const pollOptions = PollOptions.create({
        poll_options: []
    });
    const env: PollOptionsRootStoreEnv = {
        poll_options: pollOptions,
    };

    return PollOptionsRootStore.create(
        {
            poll_options: pollOptions
        },
        env
    )
};