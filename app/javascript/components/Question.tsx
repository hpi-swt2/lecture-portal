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

    const canQuestionBeUpvoted: boolean =
        question.canBeUpvoted();
    const isQuestionAlreadyUpvoted: boolean =
        question.isAlreadyUpvoted();
    const canQuestionBeResolved: boolean =
        question.canBeResolved();

    const onResolveClick = _ => {
        canQuestionBeResolved && question.resolveClick()
    };

    const onUpvoteClick = _ => {
        canQuestionBeUpvoted && question.upvoteClick()
    };
    return (
        <li key={question.id}>
            <div className={"questionUpvotes " + (!canQuestionBeUpvoted ? "disabled" : "") + (isQuestionAlreadyUpvoted ? " upvoted" : "")}>
                <div className="arrow" onClick={onUpvoteClick} />
                <p className="count">{question.upvotes}</p>
            </div>
            <div className="questionContent">
                {question.content}
            </div>

            {canQuestionBeResolved &&
                <button className={"btn btn-secondary " + (is_student ? "btn-sm" : "btn-lg")} onClick={onResolveClick}>
                    mark as solved
                </button>}
        </li>
    );
};

export default observer(QuestionView)
