import { types, Instance, IAnyStateTreeNode, getRoot } from "mobx-state-tree"
import UpdatesList, {UpdatesListModel} from "./UpdatesList";

export type UpdatesRootStoreModel = Instance<typeof UpdatesRootStore>

export type UpdatesRootStoreEnv = {
    updatesList: UpdatesListModel,
}

export const getUpdatesRootStore = (target: IAnyStateTreeNode): UpdatesRootStoreModel => {
    return getRoot(target) as UpdatesRootStoreModel
};

const UpdatesRootStore = types.model("UpdatesRootStore", {
    user_id: types.optional(types.integer, -1),
    lecture_id: types.optional(types.integer, -1),
    is_student: types.optional(types.boolean, true),
    updatesList: UpdatesList,
}).actions(self => ({
    setUserId(user_id: number) {
        self.user_id = user_id;
    },
    setIsStudent(is_student: boolean) {
        self.is_student = is_student;
        //Default sorting shall be time based for student and upvote based for lecturers
        self.updatesList.questionsList.is_sorted_by_time = is_student;
    },
    setLectureId(lecture_id: number) {
        self.lecture_id = lecture_id
    }
}));

export default UpdatesRootStore