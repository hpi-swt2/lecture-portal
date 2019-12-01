import React from "react";
import { HEADERS } from "./constants";
import QuestionsForm from "./QuestionsForm";
import QuestionsList from "./QuestionsList";

class Questions extends React.Component {
  state = {
    is_student: this.props.is_student
  };

  render = () => {
    return (
      <div>
        {this.state.is_student ? <QuestionsForm /> : null}
        <QuestionsList is_student={this.state.is_student} />
      </div>
    );
  };
}
export default Questions;
