import {Instance, types} from "mobx-state-tree";
import QuestionsList from "./QuestionsList";
import {observable} from "mobx";
import {UpdateItem, UpdateTypes} from "./UpdateItem";

export type UpdatesListModel = Instance<typeof UpdatesList>

const UpdatesList = types
    .model({
        questions-list: QuestionsList
    })
    .views(self => ({
        getList() {
            let updatesList = [];
            self.questions-list.list.forEach((question) => {
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
            self.questions-list.setQuestionsList(questionData)
        }
    }));

export default UpdatesList;
