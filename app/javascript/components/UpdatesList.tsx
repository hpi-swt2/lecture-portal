import React from "react";
import { observer } from "mobx-react";
import Update from "./Update";
import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore";
import useInject from "../hooks/useInject"

const mapStore = ({ is_student, questionsList }: QuestionsRootStoreModel) => ({
  is_student,
  questionsList
});

const UpdatesList: React.FunctionComponent<{}> = observer(() => {
  const { is_student, questionsList } = useInject(mapStore);

  const onSortingClick = e => {
    questionsList.toggleSorting()
  }

  return (
    <div className="questionsList">
      <ul className={(is_student ? "" : "is_lecturer")}>
        {questionsList.list.map(question => (
          <Update question={question} key={question.id} />
        ))}
      </ul>
    </div>
  );
});

export default UpdatesList;
