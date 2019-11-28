import React from 'react';
import {API_ROOT, API_WS_ROOT, HEADERS} from './constants';

class QuestionsList extends React.Component {
    state = {
        content: '',
        author: 'Tester',
        questions: []
    };

    componentDidMount = () => {
        console.log("Mount");
        fetch(`${API_ROOT}/api/questions`)
            .then(res => res.json())
            .then(questions => this.setState({ questions: questions }));

        App.cable.subscriptions.create( { channel: "QuestionsChannel"},
            {
                received: (data) => {
                    const { question } = data;
                    this.setState({questions: [question, ...this.state.questions]})
                }
        });
    };

    render = () => {
        const { questions } = this.state;
        return (
            <ul>{mapQuestions(questions)}</ul>
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