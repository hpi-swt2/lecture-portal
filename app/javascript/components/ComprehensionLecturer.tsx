import React, {createRef, useEffect} from "react";
import { observer } from "mobx-react";
import {ComprehensionRootStoreModel} from "../stores/ComprehensionRootStore";
import {useInjectComprehension} from "../hooks/useInject";

const mapStore = ({ last_updated, participants }: ComprehensionRootStoreModel) => ({
    last_updated,
    participants
});

const ComprehensionLecturer: React.FunctionComponent<{}> = observer(() => {
    const { last_updated, participants } = useInjectComprehension(mapStore);

    const canvasRef = createRef<HTMLCanvasElement>();

    useEffect(() => {
        const ctx = canvasRef.current.getContext("2d");
        ctx.font = "40px Courier";
        ctx.fillText("Test", 0, 0);
    }, []);

    return (
        <div>
            <p>Last Updated: {last_updated}</p>
            <p>{participants} Participants</p>
            <div className="comprehensionResults">
                <canvas ref={canvasRef} width={"100%"} height={"100%"} />
            </div>
            <div className="comprehensionLegend">
                <p>Legend here...</p>
            </div>
        </div>
    );
});

export default ComprehensionLecturer
