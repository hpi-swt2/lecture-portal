import * as React from "react"


interface IPollOptionProps {
    options: Array<string>;
    title: string
}
interface IPollOptionState {
    numberOfOptions: number;
}

class PollOption extends React.Component <IPollOptionProps, IPollOptionState> {
    constructor(props) {
        super(props);
        this.state = {numberOfOptions: props.options.length}
    }

    // We chose blur as an event so that a mistyped input does not directly erase any of the currently existing options.
    // So this component only updates the view when the input focus leaves the number field.
    onInput(evt) {
        if (evt.currentTarget && evt.currentTarget.value) {
            this.setState({numberOfOptions: evt.currentTarget.value});
        }
    }

    renderOptions() {
        const options = [];
        for (let index = 1; index <= this.state.numberOfOptions; ++index) {
            const currentOption = <React.Fragment key={`frag_${index}`}>
                <br key={`br_${index}`}/>
                <label key={`option_${index}_label`}>{index}. Option {" "} </label>
                <input id={`poll_option_${index}`} name={`poll[poll_options[option_${index}]]`} type="text" key={`${index}`} defaultValue={this.props.options[index-1]}/></React.Fragment>;
            options.push(currentOption);
        }
        return options;
    }

    render() {
        const allOptions = this.renderOptions();
        // {" "} forces a space
        return <React.Fragment>

            <div className="field">
                <label>Number of Options {" "}</label>
                <input id="number_of_options" name="number_of_options" type="number" onInput={(evt) => this.onInput(evt)} min={2} defaultValue={this.props.options.length}/>
                {allOptions}
            </div>
        </React.Fragment>
            ;
    }

}

export default PollOption
