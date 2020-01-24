import { Instance, types } from "mobx-state-tree";
import { resolveQuestionById, upvoteQuestionById } from "../utils/QuestionsUtils";
import { getQuestionsRootStore } from "./QuestionsRootStore";
import { getUpdatesRootStore } from "./UpdatesRootStore";

export type QuestionModel = Instance<typeof Question>

const Question = types
  .model({
    id: types.integer,
    content: types.string,
    author_id: types.integer,
    created_at: types.Date,
    upvotes: types.optional(types.integer, 0),
    already_upvoted: types.boolean,
    resolved: types.boolean
  })
  .views(self => ({
    canBeUpvoted(): boolean {
      const store = getQuestionsRootStore(self);
      return self.author_id != store.user_id && store.is_student && store.interactions_enabled;
    },
    isAlreadyUpvoted(): boolean {
      const store = getQuestionsRootStore(self);
      return self.already_upvoted && (self.author_id != store.user_id && store.is_student);
    },
    canBeResolved(): boolean {
      const store = getQuestionsRootStore(self);
      return (store.user_id == self.author_id || !store.is_student) && store.interactions_enabled;
    }
  }))
  .actions(self => ({
    upvote() {
      self.upvotes++;
    },
    disallowUpvote() {
      self.already_upvoted = true;
    },
    updateClick(is_student: boolean) {
      if (is_student)
        upvoteQuestionById(self.id);
      else
        resolveQuestionById(self.id);
    },
    upvoteClick() {
      upvoteQuestionById(self.id);
    }
  }));


export default Question;
