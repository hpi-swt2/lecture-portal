import {getRoot, IAnyStateTreeNode, Instance, types} from "mobx-state-tree";

export type ComprehensionRootStoreModel = Instance<typeof ComprehensionRootStore>

export const getComprehensionRootStore = (target: IAnyStateTreeNode): ComprehensionRootStoreModel => {
    return getRoot(target) as ComprehensionRootStoreModel
};

const ComprehensionRootStore = types.model("ComprehensionRootStore", {
    user_id: types.optional(types.integer, -1),
    course_id: types.optional(types.integer, -1),
    lecture_id: types.optional(types.integer, -1),
    is_student: types.optional(types.boolean, true),
    interactions_enabled: types.optional(types.boolean, true),

    last_updated: types.optional(types.maybeNull(types.Date), null),
    // for student
    active_stamp: types.optional(types.number, -1),
    // for lecturer
    results: types.optional(types.array(types.number), []),
}).actions(self => ({
    setUserId(user_id: number) {
        self.user_id = user_id;
    },
    setIsStudent(is_student: boolean) {
        self.is_student = is_student;
    },
    setLectureId(lecture_id: number) {
        self.lecture_id = lecture_id
    },
    setCourseId(course_id: number) {
        self.course_id = course_id
    },

    setComprehensionState(comprehension_state) {
        if(self.is_student) {
            self.active_stamp = comprehension_state.status;
        } else {
            self.results.replace(comprehension_state.status);
        }

        if(comprehension_state.last_update != null) {
            try {
                self.last_updated = new Date(comprehension_state.last_update);
            } catch {
                self.last_updated = null;
            }
        } else
            self.last_updated = null;
    },
    setInteractionsEnabled(interactions_enabled: boolean) {
        self.interactions_enabled = interactions_enabled
    }
}));

export default ComprehensionRootStore