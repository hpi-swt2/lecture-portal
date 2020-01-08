import { Instance, types } from "mobx-state-tree";

export type PollModel = Instance<typeof Poll>

const Poll = types
  .model({
    id: types.integer,
    lecture_id: types.integer,
    title: types.string,
    poll_options: types.array(types.model("Option", {id: types.number, description: types.string, poll_id: types.number, created_at: types.string, updated_at: types.string,votes: types.number})),
    created_at: types.string
  });


export default Poll;
