import RootStore, {RootStoreEnv, RootStoreModel} from "./RootStore";
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

    return RootStore.create(
        {
            current_question: currentQuestion,
            questionsList: questionsList
        },
        env
    )
};