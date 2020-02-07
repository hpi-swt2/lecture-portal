import React from "react";
import { observer } from "mobx-react";
import { UpdatesRootStoreModel } from "../stores/UpdatesRootStore";
import { useInjectUpdates } from "../hooks/useInject";
import Update from "./Update";

const mapStore = ({ is_student, updatesList }: UpdatesRootStoreModel) => ({
  is_student,
  updatesList
});

function EmptyUpdatesMessage() {
  return <p className="text-center text-gray"> No questions asked yet </p>;
}
function Updates(props) {
  return (
    <div className="questions-list mt-1">
      <ul className={props.is_student ? "" : "is_lecturer"}>
        {props.updatesList
          .getList()
          .map(
            update =>
              update.isVisible() && <Update item={update} key={update.id} />
          )}
      </ul>
    </div>
  );
}

const UpdatesList: React.FunctionComponent<{}> = observer(() => {
  const { is_student, updatesList } = useInjectUpdates(mapStore);
  const isNotEmpty = updatesList.getList().length;

  if (isNotEmpty) {
    return <Updates is_student={is_student} updatesList={updatesList} />;
  }
  return <EmptyUpdatesMessage />;
});
export default UpdatesList;
