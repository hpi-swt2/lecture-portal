import { HEADERS } from "./constants";
import React from "react";

class QuestionsForm extends React.Component {
  formId = "questionForm";
  inputId = "questionInput";

  constructor(props) {
    super(props);

    this.state = {
      content: ""
    };
    this.formRef = React.createRef();
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleKeyDown = this.handleKeyDown.bind(this);
  }

  handleChange = e => {
    const content = e.target.value.replace(/[\r\n\v]+/g, "");
    this.setState({ content });
  };

  handleKeyDown = (e) => {
    if(e.keyCode == 13) {
      e.preventDefault();
      this.formRef.current.dispatchEvent(new Event('submit', { cancelable: true }));
    }
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
      <form
        id={this.formId}
        ref={this.formRef}
        onSubmit={this.handleSubmit}
      >
        <label for={this.inputId}>Ask a question:</label>
        <textarea
          rows="3"
          id={this.inputId}
          value={this.state.content}
          onChange={this.handleChange}
          onKeyDown={this.handleKeyDown}
        />
        <button type="submit" className="btn btn-secondary">Ask Question</button>
      </form>
    );
  }
}

export default QuestionsForm;
