import axios from "axios";
import React from "react";
import QuestionsForm from "./QuestionsForm";
import QuestionsList from "./QuestionsList";
import { StoreProvider, initQuestionsApp, createQuestionsRootStore } from "../utils/QuestionsUtils";

const rootStore = createQuestionsRootStore();

interface IQuestionsAppProps {
    user_id: number,
    is_student: boolean,
    lecture_id: number
}
const QuestionsApp: React.FunctionComponent<IQuestionsAppProps> = ({ user_id, is_student, lecture_id }) => {
    rootStore.setUserId(user_id);
    rootStore.setIsStudent(is_student);
    rootStore.setLectureId(lecture_id);
    initQuestionsApp(rootStore);
    
    return (
        <StoreProvider value={rootStore}>
            <div className="QuestionsApp">
                <QuestionsForm />
                <QuestionsList />
            </div>
        </StoreProvider>
    )
};
export default QuestionsApp;
