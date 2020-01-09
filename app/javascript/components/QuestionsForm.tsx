import React, { createRef, useEffect } from "react";
import { observer } from "mobx-react";
import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore";
import {useInjectQuestions} from "../hooks/useInject";

const mapStore = ({
  is_student,
  current_question
}: QuestionsRootStoreModel) => ({
  is_student,
  current_question
});

const QuestionsForm: React.FunctionComponent<{}> = observer(() => {
  const { is_student, current_question } = useInjectQuestions(mapStore);

  if (is_student) {
    const formRef = createRef<HTMLFormElement>();
    const textareaRef = createRef<HTMLTextAreaElement>();
    const formId = "questionForm";

    useEffect(() => textareaRef.current.focus(), []);

    const handleChange = e => {
      current_question.set(e.target.value);
    };

    const handleKeyDown = e => {
      if (e.keyCode == 13) {
        e.preventDefault();
        formRef.current.dispatchEvent(
          new Event("submit", { cancelable: true })
        );
      }
    };

    const handleSubmit = e => {
      current_question.createQuestion();
      e.preventDefault();
    };

    return (
      <form id={formId} ref={formRef} onSubmit={handleSubmit}>
        <label>Ask a question:</label>
        <textarea
          rows={3}
          ref={textareaRef}
          value={current_question.content}
          onChange={handleChange}
          onKeyDown={handleKeyDown}
        />
        <button type="submit" className="btn btn-secondary">
          Ask Question
        </button>
      </form>
    );
  }
});

export default QuestionsForm;
