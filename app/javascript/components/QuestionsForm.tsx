import { HEADERS } from "./constants";
import React from "react";

class QuestionsForm extends React.Component {
  state = {
    content: ""
  };

  constructor(props) {
    super(props);

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange = e => {
    this.setState({ content: e.target.value });
  };

  handleSubmit = e => {
    if (this.state.content.trim() != "") {
      fetch(`/api/questions`, {
        method: "POST",
        headers: HEADERS,
        body: JSON.stringify({ content: this.state.content.trim() })
      });
      this.setState({ content: "" });
    }
    e.preventDefault();
  };

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <input
          type="text"
          name="questionInput"
          value={this.state.content}
          onChange={this.handleChange}
        />
        <p>
          <input
            type="submit"
            value="Submit"
            placeholder="Please ask a question"
          />
        </p>
      </form>
    );
  }
}

export default QuestionsForm;
