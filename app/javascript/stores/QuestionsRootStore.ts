import { types, Instance } from "mobx-state-tree"
import questionsList, { QuestionsListModel } from "./QuestionsList";
import currentQuestion, { CurrentQuestionModel } from "./CurrentQuestion";

export type QuestionsRootStoreModel = Instance<typeof QuestionsRootStore>

export type QuestionsRootStoreEnv = {
    questionsList: QuestionsListModel,
    current_question: CurrentQuestionModel
}

const QuestionsRootStore = types.model("QuestionsRootStore", {
    user_id: types.optional(types.integer, -1),
    lecture_id: types.optional(types.integer, -1),
    is_student: types.optional(types.boolean, true),
    current_question: currentQuestion,
    questionsList: questionsList,
}).actions(self => ({
    setUserId(user_id) {
        self.user_id = user_id;
    },
    setIsStudent(is_student) {
        self.is_student = is_student;
        //Default sorting shall be time based for student and upvote based for lecturers
        self.questionsList.is_sorted_by_time = is_student;
    },
    setLectureId(lecture_id) {
        self.lecture_id = lecture_id
    }
}));

export default QuestionsRootStore