import React from "react";
import { observer } from "mobx-react";
import { QuestionModel } from "../stores/Question";
import { resolveQuestionById } from "../utils/QuestionsUtils";
import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore";
import useInject from "../hooks/useInject";


const mapStore = ({ user_id, is_student }: QuestionsRootStoreModel) => ({
    user_id,
    is_student
});

type Props = {
    question: QuestionModel
}

const QuestionView: React.FunctionComponent<Props> = ({ question }) => {
    const { user_id, is_student } = useInject(mapStore);

    const onClick = _ => {
        resolveQuestionById(question.id)
    };

    const className = ["btn btn-secondary"];
    if (is_student) {
        className.push("btn-sm");
    } else {
        className.push("btn-lg");
    }

    return (
        <li key={question.id}>
            <div className="questionContent">
                {question.content}
            </div>
            { (user_id == question.author_id || !is_student) &&
                <button className={className.join(" ").trim()} onClick={onClick}>
                    mark as solved
                </button>}
        </li>
    );
};


export default observer(QuestionView)