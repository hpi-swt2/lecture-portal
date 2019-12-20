import React from "react";
import { observer } from "mobx-react";
import { UpdateModel } from "../stores/Update";
import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore";
import useInject from "../hooks/useInject";

const mapStore = ({ is_student }: QuestionsRootStoreModel) => ({
    is_student
});

type Props = {
    update: UpdateModel
}

const UpdateView: React.FunctionComponent<Props> = ({ update }) => {
    const { is_student } = useInject(mapStore);
    const onClick = _ => { !is_student && update.onClick() }

    return (
        <li key={update.type + update.id} onClick={onClick}>
            <div className="questionContent p-4">
                {is_student && <span><b>{update.getTitle()}</b><br /></span>}
                {update.content}
            </div>
        </li>
    );
};

export default observer(UpdateView)
