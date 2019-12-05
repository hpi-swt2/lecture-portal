import { types } from "mobx-state-tree";

const question = types
  .model({
    id: types.integer,
    content: types.string,
    author_id: types.integer,
    created_at: types.Date
  })
  .actions(self => ({
    // increment() {
    //   self.value++;
    // },
    // decrement() {
    //   self.value--;
    // }
  }));

export default question;
