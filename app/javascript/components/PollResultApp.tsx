import * as React from "react";
import {StoreProvider, createPollOptionsRootStore, initPollOptionsApp} from "../utils/PollOptionUtils";
import PollResultTable from "./PollResultTable";
import PollResultPieChart from "./PollResultPieChart";
import PollResultBarChart from "./PollResultBarChart";

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
                <ul className="nav nav-tabs" id="pollResultTabs" role="tablist">
                    <li className="nav-item">
                        <a className="nav-link active" id="resultTable-tab" data-toggle="tab" href="#resultTable" role="tab" aria-controls="resultTable" aria-selected="true">Table</a>
                    </li>
                    <li className="nav-item">
                        <a className="nav-link" id="resultbar-tab" data-toggle="tab" href="#resultbar" role="tab" aria-controls="resultbar" aria-selected="false">Bar Chart</a>
                    </li>
                    <li className="nav-item">
                        <a className="nav-link" id="resultpie-tab" data-toggle="tab" href="#resultpie" role="tab" aria-controls="contact" aria-selected="false">Pie Chart</a>
                    </li>
                </ul>

                <div className="tab-content" id="pollResultTabsContent">
                    <div className="tab-pane fade show active" id="resultTable" role="tabpanel" aria-labelledby="resultTable-tab">
                        <PollResultTable />
                    </div>
                    <div className="tab-pane fade" id="resultbar" role="tabpanel" aria-labelledby="resultbar-tab">
                        <PollResultBarChart />
                    </div>
                    <div className="tab-pane fade" id="resultpie" role="tabpanel" aria-labelledby="resultpie-tab">
                        <PollResultPieChart />
                    </div>
                </div>
            </div>
        </StoreProvider>
    )
};

export default PollResultApp;