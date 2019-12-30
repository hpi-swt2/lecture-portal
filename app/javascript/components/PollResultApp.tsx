import * as React from "react";
import {StoreProvider, createPollOptionsRootStore, initPollOptionsApp} from "../utils/PollOptionUtils";
import {useInjectPollOptions} from "../hooks/useInject";
import {PollOptionsRootStoreModel} from "../stores/PollOptionsRootStore";

const rootStore = createPollOptionsRootStore();

const mapStore = ({ poll_options }: PollOptionsRootStoreModel) => ({
    poll_options
});

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

    const {poll_options} = useInjectPollOptions(mapStore);

    return (
        <StoreProvider value={rootStore}>
            <div className="PollResultApp">
                <div className="PollResultApp">
                    <p>This is a test</p>
                    <ul>
                        {poll_options.poll_options.map(option => (
                            <p>{option.description}</p>
                        ))}
                    </ul>

                </div>
            </div>
        </StoreProvider>
    )
};

export default PollResultApp;