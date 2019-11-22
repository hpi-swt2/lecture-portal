import ActionCable from "actioncable";
import React from "react";

class App extends React.Component {
  state = { content: "" };
  subscription;

  componentDidMount() {
    const cable = ActionCable.createConsumer("ws://localhost:3000/cable");
    this.subscription = cable.subscriptions.create("QuestionsChannel", {
      received: this.handleReceiveNewContent
    });
  }

  handleReceiveNewContent = ({ content }) => {
    if (content !== this.state.content) {
      this.setState({ content });
    }
  };

  handleChange = e => {
    this.setState({ content: e.target.value });
    this.subscription.send({ content: e.target.value, id: 1 });
  };

  render() {
    return (
      <div>
        <textarea value={this.state.content} onChange={this.handleChange} />
      </div>
    );
  }
}

export default App;
