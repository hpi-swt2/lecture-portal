import React from "react";
import { observer } from "mobx-react";
import { UpdateModel } from "../stores/Update";
import { QuestionsRootStoreModel } from "../stores/QuestionsRootStore";
import useInject from "../hooks/useInject";

const mapStore = ({ user_id, is_student }: QuestionsRootStoreModel) => ({
    user_id,
    is_student
});

type Props = {
    update: UpdateModel
}

const UpdateView: React.FunctionComponent<Props> = ({ update }) => {
    const { user_id, is_student } = useInject(mapStore);

    return (
        <li key={update.title + update.id} >
            <div className="questionContent p-4">
                {is_student && <h3>{update.title}</h3>}
                {update.content}
            </div>
        </li >
    );
};

export default observer(UpdateView)