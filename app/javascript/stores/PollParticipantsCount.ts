import { Instance, types } from "mobx-state-tree";

export type PollParticipantsCountModel = Instance<typeof PollParticipantsCount>

const createPollParticipantsCountFromData = (countData) => {
    return PollParticipantsCount.create({
        numberOfParticipants: countData.numberOfParticipants,
        numberOfLectureUsers: countData.numberOfLectureUsers
    });
};

const PollParticipantsCount = types
    .model({
        numberOfParticipants: types.optional(types.integer, -1),
        numberOfLectureUsers: types.optional(types.integer, -1),
    })
    .actions(self => ({
        setPollParticipants(pollParticipantsData) {
            const participants = createPollParticipantsCountFromData(pollParticipantsData);
            self.numberOfParticipants = participants.numberOfParticipants;
            self.numberOfLectureUsers = participants.numberOfLectureUsers;
        }
    }));


export default PollParticipantsCount;