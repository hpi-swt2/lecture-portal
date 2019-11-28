import { ActionCableProvider } from 'react-actioncable-provider';
import { API_WS_ROOT } from './constants';
import React from "react";
import QuestionsList from './QuestionsList';
import QuestionsForm from './QuestionsForm';

class Questions extends React.Component{
  
  constructor(props) {
    super(props);
    this.state = {is_student: true};
  }

  render() {
    const is_student = this.state.is_student;
      return (
        <ActionCableProvider url={API_WS_ROOT}>
          {is_student ? <QuestionsForm content={""} author={""} /> : null}
          <QuestionsList />
        </ActionCableProvider>
      )
  }
}

export default Questions