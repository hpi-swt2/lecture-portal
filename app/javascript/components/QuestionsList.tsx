import React from "react";
import { observer } from "mobx-react";
import Question from "./Question";
import {RootStoreModel} from "../stores/QuestionsRootStore";
import useInject from "../hooks/useInject"

const mapStore = ({ is_student, questionsList }: RootStoreModel) => ({
  is_student,
  questionsList
});

const QuestionsList: React.FunctionComponent<{}> = observer(() => {
  const { is_student, questionsList } = useInject(mapStore);

  const className = ["questionsList"];
  if (!is_student) className.push("is_lecturer");

  return (
    <ul className={className.join(" ").trim()}>
      {questionsList.list.map(question => (
          <Question question={question} key={question.id} />
      ))}
    </ul>
  );
});

export default QuestionsList;
