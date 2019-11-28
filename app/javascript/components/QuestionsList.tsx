import React from 'react';
import { ActionCable } from 'react-actioncable-provider';
import { API_ROOT } from './constants';

class QuestionsList extends React.Component {
    state = {
        questions: []
    };

    componentDidMount = () => {
        fetch(`${API_ROOT}/api/questions`)
            .then(res => res.json())
            .then(questions => this.setState({ questions }));
    };

    handleReceivedQuestion = response => {
        console.log("received");
        const { question } = response;
        this.setState({
            questions: [question, ...this.state.questions]
        });
    };

    render = () => {
        const { questions } = this.state;
        return (
            <div className="questionsList">
                <ActionCable
                    channel={{ channel: 'QuestionsChannel' }}
                    onReceived={this.handleReceivedQuestion}
                />
                <ul>{mapQuestions(questions)}</ul>
            </div>
        );
    };
}

export default QuestionsList;

// helpers

const mapQuestions = (questions) => {
    return questions.map(question => {
        return (
            <li key={question.id}>
                {question.content}
            </li>
        );
    });
};