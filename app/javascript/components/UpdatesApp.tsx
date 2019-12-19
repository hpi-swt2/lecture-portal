import React from "react";
import UpdatesList from "./UpdatesList";
import { StoreProvider, initQuestionsApp, createQuestionsRootStore } from "../utils/QuestionsUtils";

const rootStore = createQuestionsRootStore();

interface IUpdatesAppProps {
    user_id: number,
    is_student: boolean,
    lecture_id: number
}

const UpdatesApp: React.FunctionComponent<IUpdatesAppProps> = ({ user_id, is_student, lecture_id }) => {
    rootStore.setUserId(user_id);
    rootStore.setIsStudent(is_student);
    rootStore.setLectureId(lecture_id);
    initQuestionsApp(rootStore);
    return (
        <StoreProvider value={rootStore}>
            <div className="UpdatesApp">
                <UpdatesList />
            </div>
        </StoreProvider>
    )
};
export default UpdatesApp;
