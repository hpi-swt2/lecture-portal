import { getRoot, IAnyStateTreeNode, Instance, types } from "mobx-state-tree";

export type StatisticsRootStoreModel = Instance<typeof StatisticsRootStore>

export const getStatisticsRootStore = (target: IAnyStateTreeNode): StatisticsRootStoreModel => {
    return getRoot(target) as StatisticsRootStoreModel
};

const StatisticsRootStore = types.model("StatisticsRootStore", {
    course_id: types.optional(types.integer, -1),
    lecture_id: types.optional(types.integer, -1),

    student_count: types.optional(types.number, 0),
    question_count: types.optional(types.number, 0),
    resolved_count: types.optional(types.number, 0)
}).actions(self => ({
    setLectureId(lecture_id: number) {
        self.lecture_id = lecture_id
    },
    setCourseId(course_id: number) {
        self.course_id = course_id
    },

    setStudentCount(student_count: number) {
        self.student_count = student_count;
    },
    setQuestionCount(question_count: number) {
        self.question_count = question_count;
    },
    setResolvedCount(resolved_count: number) {
        self.resolved_count = resolved_count;
    },

    decreaseStudentCount() {
        self.student_count--;
    },
    increaseStudentCount() {
        self.student_count++;
    },
    increaseQuestionCount() {
        self.question_count++;
    },
    increaseResolvedCount() {
        self.resolved_count++;
    }
}));

export default StatisticsRootStore