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

  return (
    <ul className={"questionsList " + (is_student ? "" : "is_lecturer")}>
      {questionsList.list.map(question => (
        <Question question={question} key={question.id} />
      ))}
    </ul>
  );
});

export default QuestionsList;
