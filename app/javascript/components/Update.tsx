import React from "react";
import { observer } from "mobx-react";

const UpdateView: React.FunctionComponent = () => {
    /*const { is_student } = useInjectUpdates(mapStore);

    const onClick = _ => { !is_student && update.onClick() }
    return (
        <li key={update.type + update.id} onClick={onClick}>
            <div className="questionContent p-4">
                {is_student && <span><b>{update.getTitle()}</b><br /></span>}
                {update.content}
            </div>
        </li>
    );*/
    return null
};

export default observer(UpdateView)
