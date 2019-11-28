import * as React from "react"


// interface IQuestionsProps {
//   content: string;
//   author: string;
// }

interface IQuestionsState {
  content: string;
}

class Questions extends React.Component <IQuestionsProps, IQuestionsState> {
  constructor(props) {
    super(props);
    this.state = {
      content: 'Please ask a question :)'
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({content: event.target.content});
  }

  handleSubmit(event) {
    alert('A question was submitted: ' + this.state.content);
    event.preventDefault();
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <textarea value={this.state.content} onChange={this.handleChange} cols={100} rows={1}/>
        <p><input type="submit" value="Submit" /></p>
      </form>
    );
  }
}

export default Questions