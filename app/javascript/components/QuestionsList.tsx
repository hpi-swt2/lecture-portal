import ActionCable from "actioncable";
import React from "react";
import { inject, observer } from "mobx-react";
import { IStoreProps } from "../models";

const CableApp = {
  cable: ActionCable.createConsumer(`/cable`)
};

class QuestionsList extends React.Component<IStoreProps> {
  componentDidMount = () => {
    fetch(`/api/questions`)
      .then(res => res.json())
      .then(questions => this.props.store.setQuestionsList(questions));

    CableApp.cable.subscriptions.create(
      { channel: "QuestionsChannel" },
      {
        received: data => {
          const { question } = data;
          this.props.store.addQuestion(question);
        }
      }
    );

    // CableApp.cable.subscriptions.create(
    //   { channel: "QuestionResolvingChannel" },
    //   {
    //     received: data => {
    //       const updatedQuestions = this.state.questions;
    //       updatedQuestions.forEach(question => {
    //         if (question.id == data) {
    //           const index = updatedQuestions.indexOf(question, 0);
    //           if (index > -1) {
    //             updatedQuestions.splice(index, 1);
    //           }
    //         }
    //       });
    //       this.setState({ questions: updatedQuestions });
    //       console.log(data);
    //     }
    //   }
    // );
  };

  render = () => {
    const divClassName = ["questionsList"];
    if (!this.props.store.is_student) divClassName.push("is_lecturer");
    return (
      <ul className={divClassName.join(" ").trim()}>
        {mapQuestions(this.props.store.questionsList)}
      </ul>
    );
  };
}

export default inject("store")(
  observer(QuestionsList as any)
) as React.ComponentType<{}>;

// helpers
const mapQuestions = questions => {
  return questions.map(question => {
    return <li key={question.id}>{question.content}</li>;
  });
};
