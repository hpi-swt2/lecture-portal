import { types, Instance } from "mobx-state-tree"
import questionsList, {QuestionsListModel} from "./QuestionsList";
import currentQuestion, {CurrentQuestionModel} from "./CurrentQuestion";

export type RootStoreModel = Instance<typeof RootStore>

export type RootStoreEnv = {
    questionsList: QuestionsListModel,
    current_question: CurrentQuestionModel
}

const RootStore = types.model("RootStore", {
    is_student: types.optional(types.boolean, true),
    current_question: currentQuestion,
    questionsList: questionsList,
});

export default RootStore