import QuestionsRootStore, {RootStoreEnv, RootStoreModel} from "./QuestionsRootStore";
import QuestionsList from "./QuestionsList";
import CurrentQuestion from "./CurrentQuestion";

export const createStore = (): RootStoreModel => {
    const questionsList = QuestionsList.create({
        list: []
    });
    const currentQuestion = CurrentQuestion.create({
        content: ""
    });
    const env: RootStoreEnv = {
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