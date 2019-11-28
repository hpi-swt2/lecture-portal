import React from 'react';
import {API_ROOT, HEADERS} from './constants';
import QuestionsList from "./QuestionsList";

class Questions extends React.Component {
    state = {
        content: ''
    };

    handleChange = e => {
        this.setState({ content: e.target.value });
    };

    handleSubmit = e => {
        fetch(`${API_ROOT}/api/questions`, {
            method: 'POST',
            headers: HEADERS,
            body: JSON.stringify(this.state)
        });
        this.setState({ content: '', author: 'Tester' });
        e.preventDefault();
    };

    render = () => {
        return (
            <div>
                <form onSubmit={this.handleSubmit}>
                    <textarea value={this.state.content} onChange={this.handleChange} cols={100} rows={1}/>
                    <p><input type="submit" value="Submit" /></p>
                </form>
                <QuestionsList />
            </div>)
    }
}

export default Questions;