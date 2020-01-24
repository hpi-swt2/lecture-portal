import React from "react";
import QuestionsForm from "./QuestionsForm";
import QuestionsList from "./QuestionsList";
import {StoreProvider, initQuestionsApp, createQuestionsRootStore, IQuestionsAppProps} from "../utils/QuestionsUtils";

const rootStore = createQuestionsRootStore();

const QuestionsApp: React.FunctionComponent<IQuestionsAppProps> = (params : IQuestionsAppProps) => {
    initQuestionsApp(rootStore, params);

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
