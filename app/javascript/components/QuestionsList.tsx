import ActionCable from "actioncable";
import React from "react";

const CableApp = {
    cable: ActionCable.createConsumer(`/cable`)
};

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

        CableApp.cable.subscriptions.create(
            { channel: "QuestionsChannel" },
            {
                received: data => {
                    const { question } = data;
                    let questions = [question, ...this.state.questions];

                    // sort questions by creation date to prevent wrong sorting
                    questions.sort((a, b): number => {
                        return (
                            new Date(b.created_at).getTime() -
                            new Date(a.created_at).getTime()
                        );
                    });

                    this.setState({ questions: questions });
                }
            }
        );


        CableApp.cable.subscriptions.create(
            { channel: "QuestionResolvingChannel" },
            {
                received: data => {
                    const updatedQuestions = this.state.questions;
                    updatedQuestions.forEach(question => {
                        if(question.id == data) {
                            const index = updatedQuestions.indexOf(question, 0);
                            if (index > -1) {
                                updatedQuestions.splice(index, 1);
                            }
                        }
                    });
                    this.setState({questions: updatedQuestions});
                    console.log(data)
                }
            }
        );
    };

    render = () => {
        const { questions } = this.state;
        const divClassName = ["questionsList"];
        if (!this.props.is_student) divClassName.push("is_lecturer");
        return (
            <ul className={divClassName.join(" ").trim()}>
                {mapQuestions(questions)}
            </ul>
        );
    };
}

export default QuestionsList;

// helpers
const mapQuestions = questions => {
    return questions.map(question => {
        return <li key={question.id}>{question.content}</li>;
    });
};
