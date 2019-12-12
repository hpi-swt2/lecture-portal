import React from "react";
import QuestionsForm from "./QuestionsForm";
import QuestionsList from "./QuestionsList";
import initQuestionsApp, {StoreProvider} from "../utils/QuestionsUtils";

const rootStore = initQuestionsApp();
//onSnapshot(rootStore, console.log);

interface IQuestionsAppProps {
    is_student: boolean
}

const QuestionsApp: React.FunctionComponent<IQuestionsAppProps> = ({is_student}) => {
    rootStore.setIsStudent(is_student);
    return (
        <StoreProvider value={rootStore}>
            <div className="QuestionsApp">
                <QuestionsForm/>
                <QuestionsList/>
            </div>
        </StoreProvider>
    )
};
export default QuestionsApp;
