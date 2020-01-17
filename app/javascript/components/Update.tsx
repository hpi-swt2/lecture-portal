import React from "react";
import { observer } from "mobx-react";
import {useInjectUpdates} from "../hooks/useInject";
import {UpdatesRootStoreModel} from "../stores/UpdatesRootStore";
import {UpdateItem} from "../stores/UpdateItem";

const mapStore = ({ is_student, interactions_enabled }: UpdatesRootStoreModel) => ({
    is_student,
    interactions_enabled
});

type Props = {
    item: UpdateItem
}

const UpdateView: React.FunctionComponent<Props> = ({item}) => {
    const { is_student, interactions_enabled } = useInjectUpdates(mapStore);

    const onClick = _ => {
        !is_student && interactions_enabled && item.onClick()
    };

    return (
        <li key={item.id} onClick={onClick} className={interactions_enabled ? "interactable" : ""}>
            <div className="questionContent p-4">
                {is_student && <span><b>{item.getTitle()}</b><br /></span>}
                {item.getContent()}
            </div>
        </li>
    );
};

export default observer(UpdateView)
