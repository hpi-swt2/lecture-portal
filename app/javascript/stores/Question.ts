import { Instance, types } from "mobx-state-tree";
import { resolveQuestionById, upvoteQuestionById } from "../utils/QuestionsUtils";
import { getQuestionsRootStore } from "./QuestionsRootStore";

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
    canBeUpvoted(): boolean {
      const store = getQuestionsRootStore(self);
      return self.author_id != store.user_id && store.is_student;
    },
    isAlreadyUpvoted(): boolean {
      const store = getQuestionsRootStore(self);
      return self.already_upvoted && (self.author_id != store.user_id && store.is_student);
    },
    canBeResolved(): boolean {
      const store = getQuestionsRootStore(self);
      return store.user_id == self.author_id || !store.is_student;
    },
    upvote() {
      self.upvotes++;
    },
    disallowUpvote() {
      self.already_upvoted = true;
    },
    resolveClick() {
      resolveQuestionById(self.id, getQuestionsRootStore(self).lecture_id);
    },
    upvoteClick() {
      upvoteQuestionById(self.id, getQuestionsRootStore(self).lecture_id);
    }
  }));


export default Question;
