import {Instance, types} from "mobx-state-tree";

export type QuestionModel = Instance<typeof Question>

const Question = types
  .model({
    id: types.integer,
    content: types.string,
    author_id: types.integer,
    created_at: types.Date,
    upvotes: types.optional(types.integer, 0),
    already_upvoted: types.boolean
  })
  .actions(self => ({
    upvote() {
      self.upvotes++;
    },
    disallowUpvote() {
      self.already_upvoted = true;
    }
  }));


export default Question;
