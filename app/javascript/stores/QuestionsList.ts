import { destroy, Instance, types } from "mobx-state-tree";
import Question, { QuestionModel } from "./Question";

export type QuestionsListModel = Instance<typeof QuestionsList>

const sortQuestionsList = (questionsList) => {
    return questionsList.slice().sort((a: QuestionModel, b: QuestionModel): number => {
        return (
            b.created_at.getTime() -
            a.created_at.getTime()
        );
    });
}

const createQuestionFromData = (questionData) => {
    return Question.create({
        id: questionData.id,
        content: questionData.content,
        author_id: questionData.author_id,
        created_at: new Date(questionData.created_at)
    });
}

const QuestionsList = types
    .model({
        list: types.optional(types.array(Question), []),
    })
    .actions(self => ({
        addQuestion(questionData) {
            self.list.push(createQuestionFromData(questionData));
            self.list = sortQuestionsList(self.list);
        },
        setQuestionsList(questionsListData) {
            self.list.clear();
            questionsListData.forEach(questionData => {
                self.list.push(createQuestionFromData(questionData));
            });
            self.list = sortQuestionsList(self.list)
        },
        resolveQuestionById(id) {
            let resolvedQuestion: QuestionModel;
            self.list.forEach(question => {
                if (question.id == id)
                    resolvedQuestion = question
            });
            if (resolvedQuestion)
                destroy(resolvedQuestion)
        }
    }));


export default QuestionsList;
