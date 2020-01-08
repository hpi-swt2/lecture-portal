import React from "react";
import { observer } from "mobx-react";
// import Poll from "./Poll";
import { PollsRootStoreModel } from "../stores/PollsRootStore";
import {useInjectPolls} from "../hooks/useInject";

const mapStore = ({ pollsList }: PollsRootStoreModel) => ({
  pollsList
});

const PollsList: React.FunctionComponent<{}> = observer(() => {
  const { pollsList } = useInjectPolls(mapStore);

  const onSortingClick = () => {
    pollsList.toggleSorting();
  };

  return (
    <div className={"pollsList"}>
      <ol className={"is_lecturer"}>
        {pollsList.list.map(poll => (
          // <Poll poll={poll} key={poll.id} />
            <li> {poll.id} , {poll.title}</li>
        ))}
      </ol>
    </div>
  );
});

export default PollsList;
