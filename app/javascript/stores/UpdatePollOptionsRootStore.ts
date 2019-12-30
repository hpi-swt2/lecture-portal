import { types, Instance, IAnyStateTreeNode, getRoot } from "mobx-state-tree"
import UpdatePollOptions, {UpdatePollOptionsModel} from "./UpdatePollOptions";

export type UpdatePollOptionsRootStoreModel = Instance<typeof UpdatePollOptionsRootStore>

export type UpdatePollOptionsRootStoreEnv = {
    poll_options: UpdatePollOptionsModel,
}

export const getUpdatePollOptionsRootStore = (target: IAnyStateTreeNode): UpdatePollOptionsRootStoreModel => {
    return getRoot(target) as UpdatePollOptionsRootStoreModel
};

const UpdatePollOptionsRootStore = types.model("UpdatePollOptionsRootStore", {
    lecture_id: types.optional(types.integer, -1),
    poll_id: types.optional(types.integer, -1),
    poll_option_ids: types.optional(types.array(types.integer), [-1]),
    poll_options: UpdatePollOptions,
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

export default UpdatePollOptionsRootStore