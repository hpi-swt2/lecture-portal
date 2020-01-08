import { types, Instance, IAnyStateTreeNode, getRoot } from "mobx-state-tree"
import pollsList, { PollsListModel } from "./PollsList";
import currentPoll, { CurrentPollModel } from "./CurrentPoll";

export type PollsRootStoreModel = Instance<typeof PollsRootStore>

export type PollsRootStoreEnv = {
    pollsList: PollsListModel,
    current_poll: CurrentPollModel
}

export const getPollsRootStore = (target: IAnyStateTreeNode): PollsRootStoreModel => {
    return getRoot(target) as PollsRootStoreModel
};

const PollsRootStore = types.model("PollsRootStore", {
    id: types.optional(types.integer, -1),
    poll_ids: types.optional(types.array(types.integer), [-1]),
    current_poll: currentPoll,
    pollsList: pollsList,
}).actions(self => ({
    setId(id: number) {
        self.id = id;
    },
    setPollIds(poll_ids) {
        self.poll_ids = poll_ids;
    }
}));

export default PollsRootStore