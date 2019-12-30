import React from "react";
import UpdatePollOptions from "./UpdatePollOptions";
import {createUpdatePollOptionsRootStore, initUpdatePollOptionsApp, StoreProvider} from "../utils/PollOptionUpdatesUtils";

const rootStore = createUpdatePollOptionsRootStore();

interface IUpdatePollOptionsAppProps {
    lecture_id: number,
    poll_id: number,
    poll_option_ids: Array<number>;
}

const UpdatePollOptionsApp: React.FunctionComponent<IUpdatePollOptionsAppProps> = ({ lecture_id, poll_id, poll_option_ids }) => {
    rootStore.setLectureId(lecture_id);
    rootStore.setPollId(poll_id);
    rootStore.setPollOptionIds(poll_option_ids);
    initUpdatePollOptionsApp(rootStore);
    return (
        <StoreProvider value={rootStore}>
            <div className="UpdatePollOptionsApp">
                <UpdatePollOptions />
            </div>
        </StoreProvider>
    )
};
export default UpdatePollOptionsApp;
