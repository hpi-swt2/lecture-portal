import React from "react";
import { HEADERS } from "./constants";

interface IQuestionsListProps {
  is_student: boolean;
}

class QuestionsList extends React.Component<IQuestionsListProps> {
  state = {
    questions: []
  };

  componentDidMount = () => {
    fetch(`/api/questions`)
      .then(res => res.json())
      .then(questions => this.setState({ questions: questions }));

    App.cable.subscriptions.create(
      { channel: "QuestionsChannel" },
      {
        received: data => {
          const { question } = data;
          let questions = [question, ...this.state.questions];

          // sort questions by creation date to prevent wrong sorting
          questions.sort((a, b): number => {
            return new Date(b.created_at) - new Date(a.created_at);
          });

          this.setState({ questions: questions });
        }
      }
    );
  };

  render = () => {
    const { questions } = this.state;
    return <ul>{mapQuestions(questions)}</ul>;
  };
}

export default QuestionsList;

// helpers
const mapQuestions = questions => {
  return questions.map(question => {
    return <li key={question.id}>{question.content}</li>;
  });
};
