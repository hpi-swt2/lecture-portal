import { Instance, types } from "mobx-state-tree";
import { resolveQuestionById } from "../utils/QuestionsUtils";

export type UpdateModel = Instance<typeof Update>

const Update = types
  .model({
    id: types.integer,
    type: types.enumeration(["Question", "Poll"]),
    content: types.string,
    author_id: types.integer,
    created_at: types.Date,
    upvotes: types.optional(types.integer, 0),
  }).actions(self => ({
    getTitle(): string {
      return self.type
    },
    onClick(lecture_id) {
      switch (self.type) {
        case "Question": {
          resolveQuestionById(self.id, lecture_id)
        }
      }
    }
  }));


export default Update;
