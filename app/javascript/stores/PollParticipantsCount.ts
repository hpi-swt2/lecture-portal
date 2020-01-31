import { Instance, types } from "mobx-state-tree";

export type PollParticipantsCountModel = Instance<typeof PollParticipantsCount>

const createPollParticipantsCountFromData = (countData) => {
    return PollParticipantsCount.create({
        number-of-participants: countData.number-of-participants,
        numberOfLectureUsers: countData.numberOfLectureUsers
    });
};

const PollParticipantsCount = types
    .model({
        number-of-participants: types.optional(types.integer, -1),
        numberOfLectureUsers: types.optional(types.integer, -1),
    })
    .actions(self => ({
        setPollParticipants(pollParticipantsData) {
            const participants = createPollParticipantsCountFromData(pollParticipantsData);
            self.number-of-participants = participants.number-of-participants;
            self.numberOfLectureUsers = participants.numberOfLectureUsers;
        }
    }));


export default PollParticipantsCount;