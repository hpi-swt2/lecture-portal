import React, {createRef, useEffect} from "react";
import { observer } from "mobx-react";
import {ComprehensionRootStoreModel} from "../stores/ComprehensionRootStore";
import {useInjectComprehension} from "../hooks/useInject";
import {formatDate} from "../utils/ComprehensionUtils";
import {
    comprehensionColors,
    comprehensionLabels,
    comprehensionStates,
    numberOfComprehensionStates
} from "../utils/constants";

const mapStore = ({ last_updated, results }: ComprehensionRootStoreModel) => ({
    last_updated,
    results
});

const ComprehensionLecturer: React.FunctionComponent<{}> = observer(() => {
    const { last_updated, results } = useInjectComprehension(mapStore);

    const canvasRef = createRef<HTMLCanvasElement>();

    useEffect(() => {
        const canvas = canvasRef.current;
        canvas.width = canvas.parentElement.offsetWidth;
        canvas.height = canvas.parentElement.offsetHeight;

        const ctx = canvas.getContext("2d");

        if(results.length == numberOfComprehensionStates) {
            const participants = countParticipants();
            let xOffset = 0;
            for(let i = 0; i < 3; i++) {
                const currentWidth = canvas.width * (results[i] / participants);
                ctx.fillStyle = comprehensionColors[i];
                ctx.fillRect(xOffset, 0, currentWidth, canvas.height);
                xOffset += currentWidth;
            }
        } else {
            // clear canvas if we get invalid data
            ctx.clearRect(0, 0, canvas.width, canvas.height)
        }
    });

    const countParticipants = () : number => {
        let participants = 0;
        for(let i = 0; i < results.length; i++) {
            participants += results[i];
        }
        return participants
    };

    const renderParticipants = () : string => {
       const participants = countParticipants();
       if(participants == 1)
           return participants + " Participant";
       return participants + " Participants"
    };

    const renderLegend = () => {
        let legendItems = [];
        for (let i = 0; i < numberOfComprehensionStates; i++) {
            legendItems.push(
                <div className="legendItem" key={i}>
                    <div>
                        <div className={comprehensionStates[i]} />
                        <span>{comprehensionLabels[i]}</span>
                    </div>
                </div>);
        }
        return legendItems;
    };

    return (
        <div>
            <span>Last Updated: {formatDate(last_updated)}</span>
            <span className={"participants"}>{renderParticipants()}</span>
            <div className="comprehensionResults">
                <canvas ref={canvasRef} width={"100%"} height={"100%"} />
            </div>
            <div className="comprehensionLegend">
                {renderLegend()}
            </div>
        </div>
    );
});

export default ComprehensionLecturer
