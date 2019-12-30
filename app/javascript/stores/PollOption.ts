import { Instance, types } from "mobx-state-tree";

export type PollOptionModel = Instance<typeof PollOption>

const PollOption = types
    .model({
        id: types.integer,
        description: types.string,
        votes: types.integer
    });

export default PollOption;
