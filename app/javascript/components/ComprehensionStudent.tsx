import React from "react";
import { observer } from "mobx-react";
import {ComprehensionRootStoreModel} from "../stores/ComprehensionRootStore";
import {useInjectComprehension} from "../hooks/useInject";
import {formatDate, updateComprehensionStamp} from "../utils/ComprehensionUtils";
import {
    comprehensionLabels,
    comprehensionStates,
    numberOfComprehensionStates
} from "../utils/constants";

const mapStore = ({ active_stamp, last_updated, lecture_id, interactions_enabled }: ComprehensionRootStoreModel) => ({
    active_stamp,
    last_updated,
    lecture_id,
    interactions_enabled
});

const ComprehensionStudent: React.FunctionComponent<{}> = observer(() => {
    const { active_stamp, last_updated, lecture_id, interactions_enabled } = useInjectComprehension(mapStore);
        
    const onComprehensionStampClick = (clickedState) => {
        return () => {
            if (interactions_enabled) {
                updateComprehensionStamp(clickedState)
            }
        }
    };

    const renderComprehensionItems = () => {
        let comprehensionItems = [];
        for (let i = 0; i < numberOfComprehensionStates; i++) {
            comprehensionItems.push(
                <div className={"comprehensionItem" + (active_stamp == i ? " active" : "")} key={i} onClick={onComprehensionStampClick(i)}>
                    <div>
                        <div className={"comprehensionButton " + comprehensionStates[i]} />
                    </div>
                    <p>{comprehensionLabels[i]}</p>
                </div>);
        }
        return comprehensionItems;
    };

    return (
        <div>
            <p>Last Updated: {formatDate(last_updated)}</p>
            <div className={"comprehensionBox" + (interactions_enabled ? "" : " disabled")}>
                {renderComprehensionItems()}
            </div>
        </div>
    );
});

export default ComprehensionStudent
