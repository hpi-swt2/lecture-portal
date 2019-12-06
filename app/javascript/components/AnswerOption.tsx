import * as React from "react"


interface IAnswerOptionProps {
  options: Array<string>;
  title: string;
  is_multiselect: boolean;
}

interface IAnswerOptionState {
  numberOfOptions: number;
  options: Array<string>;
}

class AnswerOption extends React.Component <IAnswerOptionProps, IAnswerOptionState> {
  constructor(props) {
    super(props);
    this.state = {numberOfOptions: props.options.length, options: props.options};
  }

  render() {
    const allOptions = this.renderAnswers();
    return (
      <React.Fragment>
        <h1>{this.props.title}</h1>
        {allOptions}

        <div className="actions">
          <button type="submit">
            <label>Save Answers</label>
          </button>
        </div>
      </React.Fragment>
    );
  }

  renderAnswers() {
    let boxType;
    if(this.props.is_multiselect){
      boxType = "checkbox"
    }else{
      boxType = "radio"
    }
    const options = [];
    for (let index = 1; index <= this.state.options.length; index++){
      const currentOption =
          <React.Fragment key={`frag_${index}`}>
            <br key={`br_${index}`}/>
            <input id={`poll_option_${index}`} name={"poll[option]"} type={boxType} key={`${index}`}/>
            <label key={`option_${index}_label`}> {index}. {this.state.options[index]} {" "} </label>
          </React.Fragment>;
      options.push(currentOption);
    }
    return options;
  }
}

export default AnswerOption
