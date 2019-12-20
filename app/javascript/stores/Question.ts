import { Instance, types, getRoot } from "mobx-state-tree";
import { UpdateModel } from "./Update";
import Update from "./Update";
import { resolveQuestionById, upvoteQuestionById } from "../utils/QuestionsUtils";
import { QuestionsRootStoreModel } from "./QuestionsRootStore";

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
        type: "Question",
        content: self.content,
        author_id: self.author_id,
        created_at: self.created_at,
        upvotes: self.upvotes
      })
    },
    resolveClick() {
      let lecture_id = (getRoot(self) as QuestionsRootStoreModel).lecture_id;
      resolveQuestionById(self.id, lecture_id);

    },
    upvoteClick() {
      let lecture_id = (getRoot(self) as QuestionsRootStoreModel).lecture_id;
      upvoteQuestionById(self.id, lecture_id)
    }
  }));


export default Question;
