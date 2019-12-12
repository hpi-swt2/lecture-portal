import React from "react";
import { observer } from "mobx-react";
import { QuestionModel } from "../stores/Question";
import { resolveQuestionById, upvoteQuestionById } from "../utils/QuestionsUtils";
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

    const onResolveClick = _ => {
        resolveQuestionById(question.id)
    };

    const onUpvoteClick = _ => {
        upvoteQuestionById(question.id)
    };

    return (
        <li key={question.id}>
            <div className={"questionUpvotes " + ((!question.can_be_upvoted || question.author_id == user_id || !is_student) ? "disabled" : "")}>
                <div className="arrow" onClick={onUpvoteClick} />
                <p className="count">{question.upvotes}</p>
            </div>
            <div className="questionContent">
                {question.content} ({question.author_id} und {user_id})
            </div>

            { (user_id == question.author_id || !is_student) &&
                <button className={"btn btn-secondary " + (is_student ? "btn-sm" : "btn-lg")} onClick={onResolveClick}>
                    mark as solved
                </button>}
        </li>
    );
};


export default observer(QuestionView)