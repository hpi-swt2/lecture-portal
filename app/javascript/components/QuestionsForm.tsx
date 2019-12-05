import {inject, observer} from "mobx-react";
import React from "react";
import { IStoreProps } from "../models";
import {HEADERS} from "./constants";

class QuestionsForm extends React.Component<IStoreProps> {
    formRef;
    textareaRef;
    formId = "questionForm";

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
        this.props.store.setCurrentQuestion(e.target.value);
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
        if (this.props.store.getCurrentQuestion() != "") {
            fetch(`/api/questions`, {
                method: "POST",
                headers: HEADERS,
                body: JSON.stringify({
                    content: this.props.store.getCurrentQuestion()
                })
            });
            this.props.store.clearCurrentQuestion();
        }
        e.preventDefault();
    };


    public render() {
        return (
            <form id={this.formId} ref={this.formRef} onSubmit={this.handleSubmit}>
                <label>Ask a question:</label>
                <textarea
                    rows={3}
                    ref={this.textareaRef}
                    value={this.props.store.current_question}
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


export default inject("store")(observer(QuestionsForm as any)) as React.ComponentType<{}>;