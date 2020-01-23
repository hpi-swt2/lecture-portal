import React from "react";
import { observer } from "mobx-react";
import Question from "./Question";
import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore";
import {useInjectQuestions} from "../hooks/useInject";
import {QuestionModel} from "../stores/Question";

const mapStore = ({ is_student, questionsList, interactions_enabled }: QuestionsRootStoreModel) => ({
  is_student,
  questionsList,
  interactions_enabled
});

const QuestionsList: React.FunctionComponent<{}> = observer(() => {
  const { is_student, questionsList, interactions_enabled } = useInjectQuestions(mapStore);

  const onSortingClick = () => {
    questionsList.toggleSorting();
  };

  const onFilterResolvedClick = () => {
      questionsList.toggleFilterResolved();
  };
  const onFilterUnresolvedClick = () => {
      questionsList.toggleFilterUnresolved();
  };

  const checkQuestionFiltered = (question: QuestionModel) : boolean => {
      return (question.resolved && questionsList.filter_resolved) ||
        (!question.resolved && questionsList.filter_unresolved);
  };

  return (
    <div className={"questionsList" + (interactions_enabled && is_student ? " interactions_enabled" : "" )}>
      <div className="questionsFilter">
        <div className="filtering">
            <button className={"btn btn-secondary " + (is_student ? "btn-sm" : "btn-lg") + (questionsList.filter_resolved ? " active" : "")} onClick={onFilterResolvedClick}>
                resolved
            </button>
            <button className={"btn btn-secondary " + (is_student ? "btn-sm" : "btn-lg") + (questionsList.filter_unresolved ? " active" : "")} onClick={onFilterUnresolvedClick}>
                unresolved
            </button>
        </div>
        <div className="sorting" onClick={onSortingClick}>
          {questionsList.is_sorted_by_time ? "time" : "votes"}
        </div>
      </div>
      <ul className={is_student ? "" : "is_lecturer"}>
        {questionsList.list.map(question => (
          checkQuestionFiltered(question) && <Question question={question} key={question.id} />
        ))}
      </ul>
    </div>
  );
});

export default QuestionsList;
