import PollOptionsRootStore, { PollOptionsRootStoreEnv, PollOptionsRootStoreModel } from "./PollOptionsRootStore";
import PollOptions from "./PollOptions";
import PollParticipantsCount from "./PollParticipantsCount";

export const createPollOptionsStore = (): PollOptionsRootStoreModel => {
    const pollOptions = PollOptions.create({
        poll_options: []
    });
    const participantsCount = PollParticipantsCount.create({
        number-of-participants: -1,
        numberOfLectureUsers: -1
    });
    const env: PollOptionsRootStoreEnv = {
        poll_options: pollOptions,
        poll_participants_count: participantsCount,
    };

    return PollOptionsRootStore.create(
        {
            poll_options: pollOptions,
            poll_participants_count: participantsCount
        },
        env
    )
};