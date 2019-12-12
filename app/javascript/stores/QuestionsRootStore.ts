import { types, Instance } from "mobx-state-tree"
import questionsList, { QuestionsListModel } from "./QuestionsList";
import currentQuestion, { CurrentQuestionModel } from "./CurrentQuestion";

export type QuestionsRootStoreModel = Instance<typeof QuestionsRootStore>

export type QuestionsRootStoreEnv = {
    questionsList: QuestionsListModel,
    current_question: CurrentQuestionModel
}

const QuestionsRootStore = types.model("QuestionsRootStore", {
    is_student: types.optional(types.boolean, true),
    current_question: currentQuestion,
    questionsList: questionsList,
}).actions(self => ({
    setIsStudent(is_student) {
        self.is_student = is_student;
    }
}));

export default QuestionsRootStore