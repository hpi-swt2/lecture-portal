import * as React from "react"


interface IPollOptionState {
    numberOfOptions: React.ReactNode;
}

class PollOption extends React.Component <IPollOptionState> {

    state = {
        numberOfOptions: 2
    };


    // We chose blur as an event so that a mistyped input does not directly erase any of the currently existing options.
    // So this component only updates the view when the input focus leaves the number field.
    onBlur(evt) {
        if (evt.currentTarget && evt.currentTarget.value) {
            this.setState({numberOfOptions: evt.currentTarget.value});
        }
    }

    renderOptions() {
        const options = [];
        for (let index = 1; index <= this.state.numberOfOptions; ++index) {
            const currentOption = <React.Fragment>
                <br key={index}/>
                <label key={index}>{index}. Option {" "} </label>
                <input id={`poll_${index}_option`} name={`poll[poll_options[${index}_option]]`} type="text" key={`${index}`}/></React.Fragment>;
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
                <input id="number_of_options" name="number_of_options" type="number" onBlur={(evt) => this.onBlur(evt)} min={2} defaultValue={2}/>
                {allOptions}
            </div>
        </React.Fragment>
            ;
    }

}

export default PollOption
