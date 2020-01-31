import QuestionsRootStore, { QuestionsRootStoreEnv, QuestionsRootStoreModel } from "./QuestionsRootStore";
import QuestionsList from "./QuestionsList";
import CurrentQuestion from "./CurrentQuestion";

export const createQuestionsStore = (): QuestionsRootStoreModel => {
    const questionsList = QuestionsList.create({
        list: []
    });
    const currentQuestion = CurrentQuestion.create({
        content: ""
    });
    const env: QuestionsRootStoreEnv = {
        questionsList: questionsList,
        current_question: currentQuestion
    };

    return QuestionsRootStore.create(
        {
            current_question: currentQuestion,
            questionsList: questionsList
        },
        env
    )
};