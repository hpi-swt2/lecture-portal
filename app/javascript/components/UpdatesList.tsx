import React from "react";
import { observer } from "mobx-react";
import {UpdatesRootStoreModel} from "../stores/UpdatesRootStore";
import {useInjectUpdates} from "../hooks/useInject";
import Question from "./Question";

const mapStore = ({ is_student, updatesList }: UpdatesRootStoreModel) => ({
  is_student,
  updatesList
});

const UpdatesList: React.FunctionComponent<{}> = observer(() => {
  const { is_student, updatesList } = useInjectUpdates(mapStore);

  const getItemForUpdate = (update) => {
      console.log(update);
      if(update.type == "Question")
          return <Question question={update.item} key={update.item.id} />;
      else
        return null;
  };

  return (
    <div className="questionsList mt-1">
      <ul className={(is_student ? "" : "is_lecturer")}>
        {updatesList.getList().map(update => (
            getItemForUpdate(update)
        ))}
      </ul>
    </div>
  );
});

export default UpdatesList;
