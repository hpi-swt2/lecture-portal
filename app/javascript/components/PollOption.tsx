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

    onInput(evt) {
        if (evt.currentTarget && evt.currentTarget.value) {
            this.setState({numberOfOptions: evt.currentTarget.value});
        }
    }

    renderOptions() {
        const options = [];
        for (let index = 1; index <= this.state.numberOfOptions; ++index) {
            const currentOption = <React.Fragment key={`frag_${index}`}>
                <div className="form-group">
                    <label key={`option_${index}_label`}>
                        {index}. Option {" "}
                    </label>
                    <input id={`poll_option_${index}`}
                           name={`poll[poll_options[option_${index}]]`}
                           type="text" key={`${index}`}
                           defaultValue={this.props.options[index-1]}
                           className="form-control"/>
                </div>
            </React.Fragment>;
            options.push(currentOption);
        }
        return options;
    }

    render() {
        const allOptions = this.renderOptions();
        return <React.Fragment>
            <div className="form-group">
                <label>Number of Options</label>
                <input id="number_of_options"
                       name="number_of_options"
                       type="number"
                       onInput={(evt) => this.onInput(evt)} min={2} defaultValue={this.props.options.length}
                       className="form-control"/>
                <br/>
                {allOptions}
            </div>
        </React.Fragment>
            ;
    }
}

export default PollOption
