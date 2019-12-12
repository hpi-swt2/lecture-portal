import React from "react";
import { observer } from "mobx-react";
import { QuestionModel } from "../stores/Question";
import { resolveQuestionById } from "../utils/QuestionsUtils";

type Props = {
    question: QuestionModel
}

const QuestionView: React.FunctionComponent<Props> = ({ question }) => {

    const onClick = _ => {
        resolveQuestionById(question.id)
    };

    return (
        <li key={question.id}>
            <div className="questionContent">
                {question.content}
            </div>
            <button className="btn btn-secondary btn-sm" onClick={onClick}>
                mark as solved
            </button>
        </li>
    );
};


export default observer(QuestionView)