import { Instance, types } from "mobx-state-tree";
import PollOption, { PollOptionModel } from "./PollOption";

export type PollOptionsModel = Instance<typeof PollOptions>

const createPollOptionFromData = (optionsData) => {
    return PollOption.create({
        id: optionsData.id,
        description: optionsData.description,
        votes: optionsData.votes
    });
};

const PollOptions = types
    .model({
        poll_options: types.optional(types.array(PollOption), [])
    })
    .actions(self => ({
        addPollOption(pollOptionData) {
            self.poll_options.push(createPollOptionFromData(pollOptionData));
        },
        setPollOptions(pollOptionsData) {
            self.poll_options.clear();
            pollOptionsData.forEach(pollOptionData => {
                self.poll_options.push(createPollOptionFromData(pollOptionData));
            });
        }
    }));


export default PollOptions;