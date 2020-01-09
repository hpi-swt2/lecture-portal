import React from "react";
import { observer } from "mobx-react";
import {ComprehensionRootStoreModel} from "../stores/ComprehensionRootStore";
import {useInjectComprehension} from "../hooks/useInject";
import {formatDate} from "../utils/ComprehensionUtils";

const mapStore = ({ last_updated }: ComprehensionRootStoreModel) => ({
    last_updated
});

const ComprehensionStudent: React.FunctionComponent<{}> = observer(() => {
    const { last_updated } = useInjectComprehension(mapStore);

    return (
        <div>
            <p>Last Updated: {formatDate(last_updated)}</p>
            <div className="comprehensionBox">

            </div>
        </div>
    );
});

export default ComprehensionStudent
