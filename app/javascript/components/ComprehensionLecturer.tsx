import React, {createRef, useEffect} from "react";
import { observer } from "mobx-react";
import {ComprehensionRootStoreModel} from "../stores/ComprehensionRootStore";
import {useInjectComprehension} from "../hooks/useInject";
import {formatDate} from "../utils/ComprehensionUtils";

const mapStore = ({ last_updated, participants, results }: ComprehensionRootStoreModel) => ({
    last_updated,
    participants,
    results
});

const ComprehensionLecturer: React.FunctionComponent<{}> = observer(() => {
    const { last_updated, participants, results } = useInjectComprehension(mapStore);

    const canvasRef = createRef<HTMLCanvasElement>();

    const colors = ['#98ff9c', '#ffed86', '#ff8988'];
    const labels = ['Too easy', 'Just right', 'I\'m out'];

    useEffect(() => {
        const canvas = canvasRef.current;
        canvas.width = canvas.parentElement.offsetWidth;
        canvas.height = canvas.parentElement.offsetHeight;

        const ctx = canvas.getContext("2d");
        if(results.length == 3) {
            let xOffset = 0;
            for(let i = 0; i < 3; i++) {
                const currentWidth = canvas.width * (results[i] / participants);

                ctx.fillStyle = colors[i];
                ctx.fillRect(xOffset, 0, currentWidth, canvas.height);
                xOffset += currentWidth;
            }
        }
    }, []);

    const renderLegend = () => {
        let legendItems = [];
        for (let i = 0; i < 3; i++) {
            legendItems.push(
                <div className="legendItem">
                    <div>
                        <div style={{background: colors[i]}} />
                        <span>{labels[i]}</span>
                    </div>
                </div>);
        }
        return legendItems;
    };

    return (
        <div>
            <span>Last Updated: {formatDate(last_updated)}</span>
            <span className={"participants"}>{participants} Participants</span>
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
