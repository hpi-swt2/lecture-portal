import * as React from "react";
import {StoreProvider, createPollOptionsRootStore, initPollOptionsApp} from "../utils/PollOptionUtils";
import PollResultTable from "./PollResultTable";

const rootStore = createPollOptionsRootStore();

interface IPollResultAppData {
    lecture_id: number,
    poll_id: number,
    poll_option_ids: Array<number>;
}

const PollResultApp: React.FunctionComponent<IPollResultAppData> = ({ lecture_id, poll_id, poll_option_ids }) => {
    rootStore.setLectureId(lecture_id);
    rootStore.setPollId(poll_id);
    rootStore.setPollOptionIds(poll_option_ids);
    initPollOptionsApp(rootStore);

    return (
        <StoreProvider value={rootStore}>
            <div className="PollResultApp">
                    <PollResultTable />
            </div>
        </StoreProvider>
    )
};

export default PollResultApp;