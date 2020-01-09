import React from "react";
import { observer } from "mobx-react";
import {ComprehensionRootStoreModel} from "../stores/ComprehensionRootStore";
import {useInjectComprehension} from "../hooks/useInject";

const mapStore = ({ last_updated }: ComprehensionRootStoreModel) => ({
    last_updated
});

const ComprehensionStudent: React.FunctionComponent<{}> = observer(() => {
    const { last_updated } = useInjectComprehension(mapStore);

    return (
        <div>
            <p>Last Updated: {last_updated.toString()}</p>
            <div className="comprehensionBox">

            </div>
        </div>
    );
});

export default ComprehensionStudent
