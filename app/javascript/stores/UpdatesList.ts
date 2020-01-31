import {Instance, types} from "mobx-state-tree";
import QuestionsList from "./QuestionsList";
import {observable} from "mobx";
import {UpdateItem, UpdateTypes} from "./UpdateItem";

export type UpdatesListModel = Instance<typeof UpdatesList>

const UpdatesList = types
    .model({
        questionsList: QuestionsList
    })
    .views(self => ({
        getList() {
            let updatesList = [];
            self.questionsList.list.forEach((question) => {
                updatesList.push(new UpdateItem(
                    UpdateTypes.Question,
                    observable.box(question)
                ));
            });
            return observable.array(updatesList)
        },
    }))
    .actions(self => ({
        setQuestionsList(questionData) {
            self.questionsList.setQuestionsList(questionData)
        }
    }));

export default UpdatesList;
