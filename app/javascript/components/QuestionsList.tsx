import React from "react";
import { observer } from "mobx-react";
import Question from "./Question";
import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore";
import { useInjectQuestions } from "../hooks/useInject";
import { QuestionModel } from "../stores/Question";

const mapStore = ({ is_student, questions-list, interactions_enabled }: QuestionsRootStoreModel) => ({
  is_student,
  questions-list,
  interactions_enabled
});

const QuestionsList: React.FunctionComponent<{}> = observer(() => {
  const { is_student, questions-list, interactions_enabled } = useInjectQuestions(mapStore);

  const onSortingClick = () => {
    questions-list.toggleSorting();
  };

  const onFilterResolvedClick = () => {
    questions-list.toggleFilterResolved();
  };
  const onFilterUnresolvedClick = () => {
    questions-list.toggleFilterUnresolved();
  };

  const checkQuestionFiltered = (question: QuestionModel): boolean => {
    if (!(questions-list.filter_resolved || questions-list.filter_unresolved))
      // if both filters are inactive, show all questions
      return true;
    return (question.resolved && questions-list.filter_resolved) ||
      (!question.resolved && questions-list.filter_unresolved);
  };

  return (
    <div className={"questions-list" + (interactions_enabled && is_student ? " interactions_enabled" : "")}>
      <div className="questionsFilter">
        <div className="filtering">
          <button className={"btn btn-secondary " + (is_student ? "btn-sm" : "btn-lg") + (questions-list.filter_unresolved ? " active" : "")} onClick={onFilterUnresolvedClick}>
            unresolved
            </button>
          <button className={"btn btn-secondary " + (is_student ? "btn-sm" : "btn-lg") + (questions-list.filter_resolved ? " active" : "")} onClick={onFilterResolvedClick}>
            resolved
            </button>
        </div>
        <div className="sorting" onClick={onSortingClick}>
          {questions-list.is_sorted_by_time ? "time" : "votes"}
        </div>
      </div>
      <ul className={is_student ? "" : "is_lecturer"}>
        {questions-list.list.map(question => (
          checkQuestionFiltered(question) && <Question question={question} key={question.id} />
        ))}
      </ul>
    </div>
  );
});

export default QuestionsList;
