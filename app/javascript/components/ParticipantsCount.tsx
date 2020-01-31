import React from "react";
import { observer } from "mobx-react";
import { PollOptionsRootStoreModel } from "../stores/PollOptionsRootStore";
import {useInjectPollOptions} from "../hooks/useInject";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import { faUserAlt } from '@fortawesome/free-solid-svg-icons'

const mapStore = ({ poll_participants_count }: PollOptionsRootStoreModel) => ({
    poll_participants_count
});

const ParticipantsCount: React.FunctionComponent<{}> = observer(() => {
    const { poll_participants_count } = useInjectPollOptions(mapStore);
    return (
        <div id="number-of-participants">
            <FontAwesomeIcon icon={faUserAlt} inverse className="user-icon" />
            {poll_participants_count.numberOfParticipants} of {poll_participants_count.numberOfLectureUsers} participants
         </div>
    );
});

export default ParticipantsCount;