import QuestionsRootStore, { QuestionsRootStoreEnv, QuestionsRootStoreModel } from "./QuestionsRootStore";
import QuestionsList from "./QuestionsList";
import CurrentQuestion from "./CurrentQuestion";

export const createQuestionsStore = (): QuestionsRootStoreModel => {
    const questions-list = QuestionsList.create({
        list: []
    });
    const currentQuestion = CurrentQuestion.create({
        content: ""
    });
    const env: QuestionsRootStoreEnv = {
        questions-list: questions-list,
        current_question: currentQuestion
    };

    return QuestionsRootStore.create(
        {
            current_question: currentQuestion,
            questions-list: questions-list
        },
        env
    )
};