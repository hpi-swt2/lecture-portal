import { Instance, types } from "mobx-state-tree";
import { UpdateModel } from "./Update";
import Update from "./Update";

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
    },
    createUpdate(): UpdateModel {
      return Update.create({
        id: self.id,
        title: "Question",
        content: self.content,
        author_id: self.author_id,
        created_at: self.created_at,
        upvotes: self.upvotes
      })
    }
  }));


export default Question;
