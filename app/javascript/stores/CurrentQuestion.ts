import { Instance, types } from "mobx-state-tree";
import { createQuestion } from "../utils/QuestionsUtils";
import { getQuestionsRootStore } from "./QuestionsRootStore";

export type CurrentQuestionModel = Instance<typeof CurrentQuestion>

const CurrentQuestion = types
    .model({
        content: types.optional(types.string, ""),
    })
    .actions(self => ({
        set(content: string) {
            self.content = content.replace(/[\r\n\v]+/g, "");
        },
        createQuestion() {
            if(self.content.trim() != "") {
                createQuestion(self.content.trim());
                self.content = ""
            }
        }
    }));


export default CurrentQuestion;
