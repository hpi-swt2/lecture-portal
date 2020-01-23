import React from "react";
import {
    createComprehensionRootStore,
    IComprehensionAppProps,
    initComprehensionApp,
    StoreProvider
} from "../utils/ComprehensionUtils";
import ComprehensionStudent from "./ComprehensionStudent";
import ComprehensionLecturer from "./ComprehensionLecturer";

const rootStore = createComprehensionRootStore();

const ComprehensionApp: React.FunctionComponent<IComprehensionAppProps> = (params: IComprehensionAppProps) => {
    initComprehensionApp(rootStore, params);

    return (
        <StoreProvider value={rootStore}>
            <div className="ComprehensionApp">
                {params.is_student && <ComprehensionStudent />}
                {!params.is_student && <ComprehensionLecturer />}
            </div>
        </StoreProvider>
    )
};
export default ComprehensionApp;
