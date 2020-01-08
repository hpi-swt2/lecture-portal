import PollsRootStore, { PollsRootStoreEnv, PollsRootStoreModel } from "./PollsRootStore";
import PollsList from "./PollsList";
import CurrentPoll from "./CurrentPoll";

export const createPollsStore = (): PollsRootStoreModel => {
    const pollsList = PollsList.create({
        list: []
    });
    const currentPoll = CurrentPoll.create({
        content: ""
    });
    const env: PollsRootStoreEnv = {
        pollsList: pollsList,
        current_poll: currentPoll
    };

    return PollsRootStore.create(
        {
            current_poll: currentPoll,
            pollsList: pollsList
        },
        env
    )
};