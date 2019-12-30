import { types, Instance, IAnyStateTreeNode, getRoot } from "mobx-state-tree"
import pollOptions, { PollOptionsModel } from "./PollOptions";

export type PollOptionsRootStoreModel = Instance<typeof PollOptionsRootStore>

export type PollOptionsRootStoreEnv = {
    poll_options: PollOptionsModel
}

export const getPollOptionsRootStore = (target: IAnyStateTreeNode): PollOptionsRootStoreModel => {
    return getRoot(target) as PollOptionsRootStoreModel
};

const PollOptionsRootStore = types.model("PollOptionsRootStore", {
    lecture_id: types.optional(types.integer, -1),
    poll_id: types.optional(types.integer, -1),
    poll_option_ids: types.optional(types.array(types.integer), [-1]),
    poll_options: pollOptions,
}).actions(self => ({
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