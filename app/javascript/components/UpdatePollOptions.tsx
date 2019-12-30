import React from "react";
import { observer } from "mobx-react";
import {UpdatePollOptionsRootStoreModel} from "../stores/UpdatePollOptionsRootStore";
import {useInjectPollOptionsUpdates} from "../hooks/useInject";
import Update from "./Update";

const mapStore = ({poll_options }: UpdatePollOptionsRootStoreModel) => ({
    poll_options
});

const UpdatePollOptions: React.FunctionComponent<{}> = observer(() => {
    const { poll_options } = useInjectPollOptionsUpdates(mapStore);

    return (
        <div className="poll_options mt-1">
            <ul className={(is_student ? "" : "is_lecturer")}>
                {updatesList.getList().map(update => (
                    <Update item={update} key={update.id} />
                ))}
            </ul>
        </div>
    );
});

export default UpdatePollOptions;
