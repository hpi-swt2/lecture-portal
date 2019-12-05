import React from "react";
import QuestionsForm from "./QuestionsForm";
import QuestionsList from "./QuestionsList";
import store from "../models/store";
import { Provider } from "mobx-react";

const rootStore = store.create();

const QuestionsApp: React.FC = (props) => {
  console.log(rootStore);
  return (
    <Provider store={rootStore}>
      <div className="QuestionsApp">
        <QuestionsForm />
        <QuestionsList />
      </div>
    </Provider>
  );
};
export default QuestionsApp;
