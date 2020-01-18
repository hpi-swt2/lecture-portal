import { types, Instance, IAnyStateTreeNode, getRoot } from "mobx-state-tree"
import pollOptions, { PollOptionsModel } from "./PollOptions";
import pollParticipantsCount, {PollParticipantsCountModel} from "./PollParticipantsCount";

export type PollOptionsRootStoreModel = Instance<typeof PollOptionsRootStore>

export type PollOptionsRootStoreEnv = {
    poll_options: PollOptionsModel,
    poll_participants_count: PollParticipantsCountModel
}

export const getPollOptionsRootStore = (target: IAnyStateTreeNode): PollOptionsRootStoreModel => {
    return getRoot(target) as PollOptionsRootStoreModel
};

const PollOptionsRootStore = types.model("PollOptionsRootStore", {
    course_id: types.optional(types.integer, -1),
    lecture_id: types.optional(types.integer, -1),
    poll_id: types.optional(types.integer, -1),
    poll_option_ids: types.optional(types.array(types.integer), [-1]),
    poll_options: pollOptions,
    poll_participants_count: pollParticipantsCount,
}).actions(self => ({
    setCourseId(course_id: number) {
        self.course_id = course_id
    },
    setLectureId(lecture_id: number) {
        self.lecture_id = lecture_id
    },
    setPollId(poll_id: number) {
        self.poll_id = poll_id
    },
    setPollOptionIds(poll_option_ids) {
        self.poll_option_ids = poll_option_ids
    }
}));

export default PollOptionsRootStore