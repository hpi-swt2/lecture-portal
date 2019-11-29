import { API_ROOT, HEADERS } from "./constants";
import React from "react";

class QuestionsForm extends React.Component {
  state = {
    content: "Please ask a question :)"
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
    fetch(`${API_ROOT}/api/questions`, {
      method: "POST",
      headers: HEADERS,
      body: JSON.stringify(this.state)
    });
    this.setState({ content: "" });
    e.preventDefault();
  };

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <textarea
          value={this.state.content}
          onChange={this.handleChange}
          cols={100}
          rows={1}
        />
        <p>
          <input type="submit" value="Submit" />
        </p>
      </form>
    );
  }
}

export default QuestionsForm;
