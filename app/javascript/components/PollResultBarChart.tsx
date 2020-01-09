import React from "react";
import { observer } from "mobx-react";
import { PollOptionsRootStoreModel } from "../stores/PollOptionsRootStore";
import {useInjectPollOptions} from "../hooks/useInject";
import CanvasJSReact from "../utils/canvasjs/canvasjs.react";
var CanvasJSChart = CanvasJSReact.CanvasJSChart;

const mapStore = ({ poll_options }: PollOptionsRootStoreModel) => ({
    poll_options
});

const PollResultBarChart: React.FunctionComponent<{}> = observer(() => {
    const { poll_options } = useInjectPollOptions(mapStore);
    const poll_data = poll_options.poll_options.map(option => ({y: option.votes, label: option.description}));
    const options = {
        exportEnabled: true,
        animationEnabled: true,
        data: [{
            type: "column",
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

export default PollResultBarChart;