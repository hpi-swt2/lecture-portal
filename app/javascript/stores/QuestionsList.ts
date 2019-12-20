import { destroy, Instance, types, getRoot } from "mobx-state-tree";
import Question, { QuestionModel } from "./Question";
import { getQuestionsRootStore } from "./QuestionsRootStore";

export type QuestionsListModel = Instance<typeof QuestionsList>

const sortQuestionsList = (questionsList, sortByTime: boolean) => {
    return questionsList.slice().sort(sortByTime ? timeSorting : upvoteSorting);
};

const timeSorting = (a: QuestionModel, b: QuestionModel): number => {
    return (
        b.created_at.getTime() -
        a.created_at.getTime()
    );
};

const upvoteSorting = (a: QuestionModel, b: QuestionModel): number => {
    const upvoteDiff = b.upvotes - a.upvotes;
    return upvoteDiff == 0 ? timeSorting(a, b) : upvoteDiff;
};

const createQuestionFromData = (questionData) => {
    return Question.create({
        id: questionData.id,
        content: questionData.content,
        author_id: questionData.author_id,
        created_at: new Date(questionData.created_at),
        upvotes: questionData.upvotes,
        already_upvoted: questionData.already_upvoted != null ? questionData.already_upvoted : false
    });
};

const QuestionsList = types
    .model({
        list: types.optional(types.array(Question), []),
        is_sorted_by_time: types.optional(types.boolean, false),
    })
    .actions(self => ({
        addQuestion(questionData) {
            self.list.push(createQuestionFromData(questionData));
            self.list = sortQuestionsList(self.list, self.is_sorted_by_time);
        },
        setQuestionsList(questionsListData) {
            self.list.clear();
            questionsListData.forEach(questionData => {
                self.list.push(createQuestionFromData(questionData));
            });
            self.list = sortQuestionsList(self.list, self.is_sorted_by_time)
        },
        resolveQuestionById(id: number) {
            let resolvedQuestion: QuestionModel;
            self.list.forEach(question => {
                if (question.id == id)
                    resolvedQuestion = question
            });
            if (resolvedQuestion)
                destroy(resolvedQuestion)
        },
        upvoteQuestionById(question_id: number, upvoter_id: number) {
            let upvoteQuestion: QuestionModel;
            self.list.forEach(question => {
                if (question.id == question_id)
                    upvoteQuestion = question
            });
            if (upvoteQuestion) {
                upvoteQuestion.upvote();
                !self.is_sorted_by_time && (self.list = sortQuestionsList(self.list, self.is_sorted_by_time));
                upvoter_id == getQuestionsRootStore(self).user_id && upvoteQuestion.disallowUpvote();
            }
        },
        toggleSorting() {
            self.is_sorted_by_time = !self.is_sorted_by_time;
            self.list = sortQuestionsList(self.list, self.is_sorted_by_time)
        }
    }));


export default QuestionsList;
