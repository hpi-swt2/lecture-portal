import { types } from "mobx-state-tree";
import question from "./question";
import {observable} from "mobx";

const store = types
  .model({
    is_student: types.optional(types.boolean, true),
    current_question: types.optional(types.string, ""),
    questionsList: types.optional(types.map(question), {})
  })
  .views(self => ({

  }))
  .actions(self => ({
    addQuestion(questionData) {
      self.questionsList.set(questionData.id, question.create({
        id: questionData.id,
        content: questionData.content,
        author_id: questionData.author_id,
        created_at: new Date(questionData.created_at)
      });
    },
    setQuestionsList(questionsListData) {
      self.questionsList.clear();
      questionsListData.forEach(questionData => {
        self.questionsList.set(questionData.id, question.create({
          id: questionData.id,
          content: questionData.content,
          author_id: questionData.author_id,
          created_at: new Date(questionData.created_at)
        });
      });
    },
    clearCurrentQuestion() {
      self.current_question = "";
    },
    setCurrentQuestion(content) {
      self.current_question = content.replace(/[\r\n\v]+/g, "");
    },
    getCurrentQuestion() {
      return self.current_question.trim();
    },
    getQuestionById(id) {
      return self.questionsList.get(id);
    },
    getQuestionsList() {
      //return self.questionsList.
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
