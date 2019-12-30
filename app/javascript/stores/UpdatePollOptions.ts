import {Instance, types} from "mobx-state-tree";
import PollOptions from "./PollOptions";
import {observable} from "mobx";
import {UpdatePollOption, UpdateTypes} from "./UpdatePollOption";

export type UpdatePollOptionsModel = Instance<typeof UpdatePollOptions>

const UpdatePollOptions = types
    .model({
        poll_options: PollOptions
    })
    .views(self => ({
        getPollOptions() {
            let updatesList = [];
            self.poll_options.poll_options.forEach((option) => {
                updatesList.push(new UpdatePollOption(
                    UpdateTypes.PollOption,
                    observable.box(option)
                ));
            });
            return observable.array(updatesList)
        },
    }))
    .actions(self => ({
        setPollOptions(pollOptionData) {
            self.poll_options.setPollOptions(pollOptionData)
        }
    }));

export default UpdatePollOptions;
