import React from "react";
import { observer } from "mobx-react";
import { PollOptionsRootStoreModel } from "../stores/PollOptionsRootStore";
import {useInjectPollOptions} from "../hooks/useInject";
import CanvasJSReact from "../lib/canvasjs/canvasjs.react";
import PollResultDataInitializer from "./PollResultDataInitializer";

var CanvasJSChart = CanvasJSReact.CanvasJSChart;

const mapStore = ({ poll_options }: PollOptionsRootStoreModel) => ({
    poll_options
});

const PollResultPieChart: React.FunctionComponent<{}> = observer(() => {
    const { poll_options } = useInjectPollOptions(mapStore);
    const pollDataInitializer = new PollResultDataInitializer(poll_options);
    const options = {
        colorSet: "applicationColorScheme",
        exportEnabled: true,
        animationEnabled: true,
        data: [{
            type: "pie",
            startAngle: 0,
            toolTipContent: "<b>{label}</b>: {y}%",
            indexLabelFontSize: 16,
            indexLabel: "{label} - {y}%",
            dataPoints: pollDataInitializer.getPollData(),
        }]
    }

    return (
        <div>
			<CanvasJSChart options = {options}
			/>
		    {}
	    </div>
    );
});

export default PollResultPieChart;