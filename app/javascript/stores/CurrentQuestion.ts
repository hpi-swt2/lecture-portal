import {Instance, types} from "mobx-state-tree";

export type CurrentQuestionModel = Instance<typeof CurrentQuestion>

const CurrentQuestion = types
    .model({
        content: types.optional(types.string, ""),
    })
    .actions(self => ({
        set(content) {
            self.content = content.replace(/[\r\n\v]+/g, "");
        },
        get() {
            return self.content
        },
        getTrimmed() {
            return self.content.trim()
        },
        clear() {
            self.content = ""
        }
    }));


export default CurrentQuestion;
