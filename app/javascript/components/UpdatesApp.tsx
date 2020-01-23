import React from "react";
import UpdatesList from "./UpdatesList";
import {createUpdatesRootStore, initUpdatesApp, StoreProvider} from "../utils/UpdatesUtils";

const rootStore = createUpdatesRootStore();

interface IUpdatesAppProps {
    user_id: number,
    is_student: boolean,
    lecture_id: number,
    course_id: number,
    interactions_enabled: boolean,
    questions_list: any
}

const UpdatesApp: React.FunctionComponent<IUpdatesAppProps> = ({ user_id, is_student, course_id, lecture_id, interactions_enabled, questions_list }) => {
    rootStore.setUserId(user_id);
    rootStore.setIsStudent(is_student);
    rootStore.setLectureId(lecture_id);
    rootStore.setInteractionsEnabled(interactions_enabled);
    rootStore.setCourseId(course_id);
    rootStore.updatesList.setQuestionsList(questions_list);
    initUpdatesApp(rootStore);

    return (
        <StoreProvider value={rootStore}>
            <div className="UpdatesApp">
                <UpdatesList />
            </div>
        </StoreProvider>
    )
};
export default UpdatesApp;
