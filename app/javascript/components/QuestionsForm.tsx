import { HEADERS } from "./constants";
import React from "react";

class QuestionsForm extends React.Component {
    state = {
        content: ""
    };
    formId = "questionForm";
    formRef; textareaRef;

    constructor(props) {
        super(props);

        this.formRef = React.createRef();
        this.textareaRef = React.createRef();

        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
        this.handleKeyDown = this.handleKeyDown.bind(this);
    }

    componentDidMount() {
        this.textareaRef.current.focus();
    }

    handleChange = e => {
        const content = e.target.value.replace(/[\r\n\v]+/g, "");
        this.setState({ content });
    };

    handleKeyDown = e => {
        if (e.keyCode == 13) {
            e.preventDefault();
            this.formRef.current.dispatchEvent(
                new Event("submit", { cancelable: true })
            );
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
            <form id={this.formId} ref={this.formRef} onSubmit={this.handleSubmit}>
                <label>Ask a question:</label>
                <textarea
                    rows={3}
                    ref={this.textareaRef}
                    value={this.state.content}
                    onChange={this.handleChange}
                    onKeyDown={this.handleKeyDown}
                />
                <button type="submit" className="btn btn-secondary">
                    Ask Question
                </button>
            </form>
        );
    }
}

export default QuestionsForm;
