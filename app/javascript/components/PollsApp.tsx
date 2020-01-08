import React from "react";
// import PollsForm from "./PollsForm";
import PollsList from "./PollsList";
import { StoreProvider, initPollsApp, createPollsRootStore } from "../utils/PollsUtils";
import {types} from "mobx-state-tree";

const rootStore = createPollsRootStore();

interface IPollsAppProps {
    id: number,
}

const PollsApp: React.FunctionComponent<IPollsAppProps> = ({ id }) => {
    console.log(id);
    rootStore.setId(id);
    initPollsApp(rootStore);
    return (
        <StoreProvider value={rootStore}>
            <div className="PollsApp">
                <PollsList />
            </div>
        </StoreProvider>
    )
};
export default PollsApp;
