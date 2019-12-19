import ActionCable from "actioncable";
import { createContext, useContext } from "react";
import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore";
import { createStore } from "../stores/createStore";
import { HEADERS } from "./constants";

const StoreContext = createContext<QuestionsRootStoreModel>({} as QuestionsRootStoreModel);
export const useStore = () => useContext(StoreContext);
export const StoreProvider = StoreContext.Provider;

const getBaseRequestUrl = (lectureId: number): string => {
    return `/lectures/` + lectureId + `/questions/`
};

const loadQuestionsList = (rootStore: QuestionsRootStoreModel) => {
    fetch(getBaseRequestUrl(rootStore.lecture_id))
        .then(res => res.json())
        .then(questions => {
            rootStore.questionsList.setQuestionsList(questions);
        });
};

const CableApp = {
    cable: ActionCable.createConsumer(`/cable`)
};

const setupActionCable = (rootStore: QuestionsRootStoreModel) => {
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
            received: id => {
                rootStore.questionsList.resolveQuestionById(id)
            }
        }
    );
    CableApp.cable.subscriptions.create(
        { channel: "QuestionUpvotingChannel" },
        {
            received: data => {
                const upvotedQuestion = rootStore.questionsList.upvoteQuestionById(data.question);
                if (upvotedQuestion && data.upvoter == rootStore.user_id)
                    upvotedQuestion.disallowUpvote();
            }
        }
    );
};

export const createQuestionsRootStore = (): QuestionsRootStoreModel => {
    const rootStore = createStore();
    return rootStore;
};

export const initQuestionsApp = (rootStore: QuestionsRootStoreModel) => {
    loadQuestionsList(rootStore);
    setupActionCable(rootStore);
};

export const createQuestion = (content: string, lectureId: number) => {
    fetch(getBaseRequestUrl(lectureId), {
        method: "POST",
        headers: HEADERS,
        body: JSON.stringify({
            content: content
        })
    });
};

export const resolveQuestionById = (id: number, lectureId: number) => {
    fetch(getBaseRequestUrl(lectureId) + id + '/resolve', {
        method: "POST",
        headers: HEADERS
    });
};

export const upvoteQuestionById = (id, lectureId) => {
    fetch(getBaseRequestUrl(lectureId) + id + '/upvote', {
        method: "POST",
        headers: HEADERS
    });
};
