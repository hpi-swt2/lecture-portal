import React from "react";
import UpdatesList from "./UpdatesList";
import {createUpdatesRootStore, initUpdatesApp, IUpdatesAppProps, StoreProvider} from "../utils/UpdatesUtils";

const rootStore = createUpdatesRootStore();

const UpdatesApp: React.FunctionComponent<IUpdatesAppProps> = (params: IUpdatesAppProps) => {
    initUpdatesApp(rootStore, params);

    return (
        <StoreProvider value={rootStore}>
            <div className="UpdatesApp">
                <UpdatesList />
            </div>
        </StoreProvider>
    )
};
export default UpdatesApp;
