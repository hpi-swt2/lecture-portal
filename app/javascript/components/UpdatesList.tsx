import React from "react";
import { observer } from "mobx-react";
import {UpdatesRootStoreModel} from "../stores/UpdatesRootStore";
import {useInjectUpdates} from "../hooks/useInject";
import Update from "./Update";

const mapStore = ({ is_student, updatesList }: UpdatesRootStoreModel) => ({
  is_student,
  updatesList
});

const UpdatesList: React.FunctionComponent<{}> = observer(() => {
  const { is_student, updatesList } = useInjectUpdates(mapStore);

  return (
    <div className="questionsList mt-1">
      <ul className={(is_student ? "" : "is_lecturer")}>
        {updatesList.getList().map(update => (
            <Update item={update} key={update.id} />
        ))}
      </ul>
    </div>
  );
});

export default UpdatesList;
