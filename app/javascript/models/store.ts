import { types } from "mobx-state-tree";
import question from "./question";

const store = types
  .model({
    is_student: types.optional(types.boolean, true),
    current_question: types.optional(types.string, ""),
    questionsList: types.optional(types.map(question), {})
  })
  .actions(self => ({
    addQuestion(questionData) {
      self.questionsList.put(question.create(questionData));
    },
    setQuestionsList(questionsListData) {
      self.questionsList.clear();
      questionsListData.forEach(questionData => {
        self.questionsList.put(question.create(questionData));
      });
    },
    clearCurrentQuestion() {
      self.current_question = "";
    },
    getCurrentQuestion() {
      return self.current_question.trim();
    }
    // sortQuestionsList() {
    //   // sort questions by creation date to prevent wrong sorting
    //   self.questionsList.s((a, b): number => {
    //     return (
    //       new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
    //     );
    //   });
    // }
  }));

export default store;
