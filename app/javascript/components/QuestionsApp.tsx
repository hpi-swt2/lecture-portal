import React, {createContext, useContext} from "react";
import QuestionsForm from "./QuestionsForm";
import QuestionsList from "./QuestionsList";
import {RootStoreModel} from "../stores/RootStore";
import {createStore} from "../stores/createStore";


const StoreContext = createContext<RootStoreModel>({} as RootStoreModel);

export const useStore = () => useContext(StoreContext);

export const StoreProvider = StoreContext.Provider;

const rootStore = createStore();

//onSnapshot(rootStore, console.log);
import ActionCable from "actioncable";

const CableApp = {
    cable: ActionCable.createConsumer(`/cable`)
};

fetch(`/api/questions`)
    .then(res => res.json())
    .then(questions => {
        rootStore.questionsList.setQuestionsList(questions);
    });

CableApp.cable.subscriptions.create(
    { channel: "QuestionsChannel" },
    {
        received: data => {
            const { question } = data;
            rootStore.questionsList.addQuestion(question);
        }
    }
);

CableApp.cable.subscriptions.create(
  { channel: "QuestionResolvingChannel" },
  {
    received: data => {
        rootStore.questionsList.resolveQuestionById(data)
    }
  }
);


const QuestionsApp: React.FunctionComponent<{}> = () => (
    <StoreProvider value={rootStore}>
      <div className="QuestionsApp">
        <QuestionsForm />
        <QuestionsList />
      </div>
    </StoreProvider>
);
export default QuestionsApp;
