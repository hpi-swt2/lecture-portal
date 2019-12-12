import { Instance, types } from "mobx-state-tree";

export type QuestionModel = Instance<typeof Question>

const Question = types
  .model({
    id: types.integer,
    content: types.string,
    author_id: types.integer,
    created_at: types.Date,
    upvotes: types.optional(types.integer, 0),
    can_be_upvoted: types.optional(types.boolean, true)
  })
  .actions(self => ({
    upvote() {
      self.upvotes++;
    },
    disallowUpvote() {
      self.can_be_upvoted = false;
    }
  }));


export default Question;
