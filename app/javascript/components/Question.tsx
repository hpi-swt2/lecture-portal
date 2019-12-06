import React from "react";
import { observer } from "mobx-react";
import {QuestionModel} from "../stores/question";
import {HEADERS} from "./constants";

type Props = {
    question: QuestionModel
}

const QuestionView: React.FunctionComponent<Props> = ({ question }) => {

    const onClick = _ => {
        fetch(`/api/questions/` + question.id + '/resolve', {
            method: "POST",
            headers: HEADERS
        });
    };

    return (
        <li key={question.id}>{question.content} <button onClick={onClick}/></li>
    );
};


export default observer(QuestionView)