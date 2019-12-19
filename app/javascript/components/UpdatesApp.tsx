import React from "react";
import UpdatesList from "./UpdatesList";
import { StoreProvider, initQuestionsApp, createQuestionsRootStore } from "../utils/QuestionsUtils";

const rootStore = createQuestionsRootStore();
//onSnapshot(rootStore, console.log);

interface IUpdatesAppProps {
    user_id: number,
    is_student: boolean
}

const UpdatesApp: React.FunctionComponent<IUpdatesAppProps> = ({ user_id, is_student }) => {
    rootStore.setUserId(user_id);
    rootStore.setIsStudent(is_student);
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
