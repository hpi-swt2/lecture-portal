import { Instance, types } from "mobx-state-tree";
import { getPollsRootStore } from "./PollsRootStore";
import { createPoll } from "../utils/PollsUtils"

export type CurrentPollModel = Instance<typeof CurrentPoll>

const CurrentPoll = types
    .model({
        content: types.optional(types.string, ""),
    })
    .actions(self => ({
        set(content: string) {
            self.content = content.replace(/[\r\n\v]+/g, "");
        },
        createPoll() {
            if(self.content.trim() != "") {
                createPoll(self.content.trim(), getPollsRootStore(self).id);
                self.content = ""
            }
        }
    }));


export default CurrentPoll;
