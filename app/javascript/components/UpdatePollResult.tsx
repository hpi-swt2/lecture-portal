import React from "react";
import { observer } from "mobx-react";
import {UpdatePollOption} from "../stores/UpdatePollOption";

type Props = {
    poll_option: UpdatePollOption
}

const UpdatePollOptionView: React.FunctionComponent<Props> = ({poll_option}) => {
    return (
        <li key={poll_option.id} >
            <div >
                {poll_option.getDescription()}
            </div>
        </li>
    );
};

export default observer(UpdatePollOptionView)
