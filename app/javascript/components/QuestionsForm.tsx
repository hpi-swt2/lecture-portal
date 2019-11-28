import { API_ROOT, HEADERS } from './constants';
import React from "react";

interface IQuestionsProps {
    content: string;
    author: string;
}
  
interface IQuestionsState {
    author: string,
    content: string;
}
  
class QuestionsForm extends React.Component <IQuestionsProps, IQuestionsState>{

    constructor(props) {
        super(props);
        this.state = {
          author: 'Tester',
          content: 'Please ask a question :)'
        };
    
        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
      }
    
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

    render() {
        return (
            <form onSubmit={this.handleSubmit}>
                <textarea value={this.state.content} onChange={this.handleChange} cols={100} rows={1}/>
                <p><input type="submit" value="Submit" /></p>
            </form>
        )
    } 
}

export default QuestionsForm;