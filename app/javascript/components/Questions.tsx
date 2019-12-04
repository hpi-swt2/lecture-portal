import React from "react";
import { HEADERS } from "./constants";
import QuestionsForm from "./QuestionsForm";
import QuestionsList from "./QuestionsList";

interface IQuestionsProps {
  is_student: boolean;
}

class Questions extends React.Component<IQuestionsProps> {
  render = () => {
    return (
        <div>
          {this.props.is_student ? <QuestionsForm /> : null}
          <QuestionsList is_student={this.props.is_student} />
        </div>
    );
  };
}
export default Questions;
