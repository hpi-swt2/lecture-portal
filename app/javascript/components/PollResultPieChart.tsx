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
    const poll_data = poll_options.poll_options.map(option => ({y: (option.votes / allVotes), label: option.description}))
    console.log("poll_data: ", poll_data)
    console.log(poll_options.poll_options)
    const options = {
        // exportEnabled: true,
        animationEnabled: true,
        //title: {
        //    text: ""
        //},
        data: [{
            type: "pie",
            startAngle: 0,
            //toolTipContent: "<b>{label}</b>: {y}%",
            //showInLegend: "true",
            //legendText: "{label}",
            indexLabelFontSize: 16,
            indexLabel: "{label} - {y}%",
            dataPoints: poll_data
        }]
    }
    

    return (
        <div>
			<CanvasJSChart options = {options}
				/* onRef={ref => this.chart = ref} */
			/>
		    {/*You can get reference to the chart instance as shown above using onRef. This allows you to access all chart properties and methods*/}
	    </div>
    );
});

export default PollResultPieChart;