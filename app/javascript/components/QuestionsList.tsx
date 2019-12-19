import React from "react";
import { observer } from "mobx-react";
import Question from "./Question";
import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore";
import useInject from "../hooks/useInject"

const mapStore = ({ is_student, questionsList }: QuestionsRootStoreModel) => ({
  is_student,
  questionsList
});

const QuestionsList: React.FunctionComponent<{}> = observer(() => {
  const { is_student, questionsList } = useInject(mapStore);

  const onSortingClick = e => {
    questionsList.toggleSorting()
  }

  return (
    <div className="questionsList">
      <div className="questionsFilter">
        <div className="sorting" onClick={onSortingClick}>
          {questionsList.is_sorted_by_time ? "time" : "votes"}
        </div>
      </div>
      <ul className={(is_student ? "" : "is_lecturer")}>
        {questionsList.list.map(question => (
          <Question question={question} key={question.id} />
        ))}
      </ul>
    </div>
  );
});

export default QuestionsList;
