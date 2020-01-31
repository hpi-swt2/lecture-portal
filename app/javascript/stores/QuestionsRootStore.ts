import { types, Instance, IAnyStateTreeNode, getRoot } from "mobx-state-tree"
import questions-list, { QuestionsListModel } from "./QuestionsList";
import currentQuestion, { CurrentQuestionModel } from "./CurrentQuestion";

export type QuestionsRootStoreModel = Instance<typeof QuestionsRootStore>

export type QuestionsRootStoreEnv = {
    questions-list: QuestionsListModel,
    current_question: CurrentQuestionModel
}

export const getQuestionsRootStore = (target: IAnyStateTreeNode): QuestionsRootStoreModel => {
    return getRoot(target) as QuestionsRootStoreModel
};

const QuestionsRootStore = types.model("QuestionsRootStore", {
    user_id: types.optional(types.integer, -1),
    course_id: types.optional(types.integer, -1),
    lecture_id: types.optional(types.integer, -1),
    interactions_enabled: types.optional(types.boolean, true),

    is_student: types.optional(types.boolean, true),
    current_question: currentQuestion,
    questions-list: questions-list,
}).actions(self => ({
    setUserId(user_id: number) {
        self.user_id = user_id;
    },
    setIsStudent(is_student: boolean) {
        self.is_student = is_student;
        //Default sorting shall be time based for student and upvote based for lecturers
        self.questions-list.is_sorted_by_time = is_student;
    },
    setLectureId(lecture_id: number) {
        self.lecture_id = lecture_id
    },
    setCourseId(course_id: number) {
        self.course_id = course_id
    },
    setInteractionsEnabled(interactions_enabled: boolean) {
        self.interactions_enabled = interactions_enabled
    }
}));

export default QuestionsRootStore