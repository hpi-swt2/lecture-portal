import { Instance, types } from "mobx-state-tree";

export type UpdateModel = Instance<typeof Update>

const Update = types
  .model({
    id: types.integer,
    title: types.string,
    content: types.string,
    author_id: types.integer,
    created_at: types.Date,
    upvotes: types.optional(types.integer, 0),
  });


export default Update;
