import React from "react";
import { observer } from "mobx-react";
import { QuestionModel } from "../stores/Question";
import { resolveQuestionById, upvoteQuestionById } from "../utils/QuestionsUtils";

type Props = {
    question: QuestionModel
}

const QuestionView: React.FunctionComponent<Props> = ({ question }) => {

    const onResolveClick = _ => {
        resolveQuestionById(question.id)
    };

    const onUpvoteClick = _ => {
        upvoteQuestionById(question.id)
    };

    return (
        <li key={question.id}>
            <div className="questionContent">
                {question.content}
            </div>
            <button className="btn btn-secondary btn-sm" onClick={onResolveClick}>
                mark as solved
            </button>
            <button className="btn btn-secondary btn-sm" onClick={onUpvoteClick}>{question.upvotes}</button>
        </li>
    );
};


export default observer(QuestionView)