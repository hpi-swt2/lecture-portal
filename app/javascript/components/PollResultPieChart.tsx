import React from "react";
import { observer } from "mobx-react";
import { PollOptionsRootStoreModel } from "../stores/PollOptionsRootStore";
import {useInjectPollOptions} from "../hooks/useInject";
import { render } from "react-dom";
import CanvasJSReact from "../utils/canvasjs/canvasjs.react";
var CanvasJS = CanvasJSReact.CanvasJS;
var CanvasJSChart = CanvasJSReact.CanvasJSChart;
var Component = React.Component

const mapStore = ({ poll_options }: PollOptionsRootStoreModel) => ({
    poll_options
});

const PollResultPieChart: React.FunctionComponent<{}> = observer(() => {
    const { poll_options } = useInjectPollOptions(mapStore);
    const allVotes = poll_options.poll_options.map(option => option.votes).reduce((a, b) => a + b, 0);
    allVotes = (allVotes === 0) ? 1 : allVotes;
    const poll_data = poll_options.poll_options.map(option => ({y: (option.votes / allVotes).toFixed(2) * 100, label: option.description}));
    const options = {
        exportEnabled: true,
        animationEnabled: true,
        data: [{
            type: "pie",
            startAngle: 0,
            toolTipContent: "<b>{label}</b>: {y}%",
            indexLabelFontSize: 16,
            indexLabel: "{label} - {y}%",
            dataPoints: poll_data
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