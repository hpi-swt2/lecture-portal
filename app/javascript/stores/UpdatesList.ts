import { Instance, types } from "mobx-state-tree";
import QuestionsList from "./QuestionsList";
import {observable} from "mobx";

export type UpdatesListModel = Instance<typeof UpdatesList>

const UpdatesList = types
    .model({
        questionsList: QuestionsList
    })
    .actions(self => ({
        getList() {
            let updatesList = [];
            console.log("Ich passiere.");
            self.questionsList.list.forEach((question) => {
                updatesList.push({
                    type: "Question",
                    item: observable.box(question)
                });
            });
            return observable.array(updatesList)
        },
        setQuestionsList(questionData) {
            self.questionsList.setQuestionsList(questionData)
        }
    }));


export default UpdatesList;
