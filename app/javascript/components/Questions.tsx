import React from "react";
import { API_ROOT, HEADERS } from "./constants";
import QuestionsForm from "./QuestionsForm";
import QuestionsList from "./QuestionsList";

class Questions extends React.Component {
  state = {
    is_student: true
  };

  handleChange = e => {
    this.setState({ content: e.target.value });
  };

  handleSubmit = e => {
    fetch(`${API_ROOT}/api/questions`, {
      method: "POST",
      headers: HEADERS,
      body: JSON.stringify(this.state)
    });
    this.setState({ content: "", author: "Tester" });
    e.preventDefault();
  };

  render = () => {
    return (
      <div>
        {this.state.is_student ? (
          <QuestionsForm content={""} author={""} />
        ) : null}
        <QuestionsList />
      </div>
    );
  };
}
export default Questions;
