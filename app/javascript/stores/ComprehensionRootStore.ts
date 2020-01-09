import {getRoot, IAnyStateTreeNode, Instance, types} from "mobx-state-tree";

export type ComprehensionRootStoreModel = Instance<typeof ComprehensionRootStore>

export const getComprehensionRootStore = (target: IAnyStateTreeNode): ComprehensionRootStoreModel => {
    return getRoot(target) as ComprehensionRootStoreModel
};

const ComprehensionRootStore = types.model("ComprehensionRootStore", {
    user_id: types.optional(types.integer, -1),
    lecture_id: types.optional(types.integer, -1),
    is_student: types.optional(types.boolean, true),

    results: types.optional(types.array(types.number), []),
    participants: types.optional(types.integer, 0),
    last_updated: types.optional(types.Date, () => new Date())
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

    setParticipants(participants: number) {
        self.participants = participants
    }
}));

export default ComprehensionRootStore