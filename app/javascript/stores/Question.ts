import { Instance, types } from "mobx-state-tree";

export type QuestionModel = Instance<typeof Question>

const Question = types
  .model({
    id: types.integer,
    content: types.string,
    author_id: types.integer,
    created_at: types.Date,
    upvotes: types.optional(types.integer, 0)
  })
  .actions(self => ({
    upvote() {
      self.upvotes++;
    }
  }));


export default Question;
