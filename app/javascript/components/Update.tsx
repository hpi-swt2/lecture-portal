import React from "react";
import { observer } from "mobx-react";
import { QuestionModel } from "../stores/Question";
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

    return (
        <li key={question.id}>
            <div className="questionContent ml-4 mr-4">
                {question.content}
            </div>
        </li>
    );
};

export default observer(QuestionView)