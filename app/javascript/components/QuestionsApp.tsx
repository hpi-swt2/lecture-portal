import React from "react";
import QuestionsForm from "./QuestionsForm";
import QuestionsList from "./QuestionsList";
import store from "../models/store";
import { Provider } from "mobx-react";

const rootStore = store.create();

const QuestionsApp: React.FC = () => {
  return (
    <Provider store={rootStore}>
      <div className="App">
        {rootStore.is_student ? <QuestionsForm /> : null}
        <QuestionsList />
      </div>
    </Provider>
  );
};
export default QuestionsApp;
