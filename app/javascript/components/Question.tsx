import React from "react";
import { observer } from "mobx-react";
import {QuestionModel} from "../stores/Question";
import {resolveQuestionById} from "../utils/QuestionsUtils";

type Props = {
    question: QuestionModel
}

const QuestionView: React.FunctionComponent<Props> = ({ question }) => {

    const onClick = _ => {
        resolveQuestionById(question.id)
    };

    return (
        <li key={question.id}>{question.content} <button onClick={onClick}/></li>
    );
};


export default observer(QuestionView)