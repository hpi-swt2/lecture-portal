import {Instance, types} from "mobx-state-tree";

export type QuestionModel = Instance<typeof Question>

const Question = types
  .model({
    id: types.integer,
    content: types.string,
    author_id: types.integer,
    created_at: types.Date
  });


export default Question;
