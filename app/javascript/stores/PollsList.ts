import { destroy, Instance, types } from "mobx-state-tree";
import Poll, { PollModel } from "./Poll";
import  { getPollsRootStore } from "./PollsRootStore";

export type PollsListModel = Instance<typeof PollsList>

const sortPollsList = (pollsList) => {
    // return pollsList.slice().sort(timeSorting);
    return pollsList
};

/*
const timeSorting = (a: PollModel, b: PollModel): number => {
    return (
        b.created_at.getTime() -
        a.created_at.getTime()
    );
};
*/

const createPollFromData = (pollData) => {
    console.log(pollData);
    return Poll.create({
        id: pollData.id,
        lecture_id: pollData.lecture_id,
        title: pollData.title,
        poll_options: pollData.poll_options,
        created_at: pollData.created_at
    });
};

const PollsList = types
    .model({
        list: types.optional(types.array(Poll), []),
        is_sorted_by_time: types.optional(types.boolean, false),
    })
    .actions(self => ({
        addPoll(pollData) {
            self.list.push(createPollFromData(pollData));
            self.list = sortPollsList(self.list);
        },
        setPollsList(pollsListData) {
            self.list.clear();
            pollsListData.forEach(pollData => {
                self.list.push(createPollFromData(pollData.poll));
            });
            self.list = sortPollsList(self.list);
        },
        toggleSorting() {
            self.is_sorted_by_time = !self.is_sorted_by_time;
            self.list = sortPollsList(self.list)
        }
    }));


export default PollsList;
