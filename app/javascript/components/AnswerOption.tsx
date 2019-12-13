import * as React from "react"
import {ChangeEvent} from "react";
import ts from "typescript/lib/tsserverlibrary";
import nullCancellationToken = ts.server.nullCancellationToken;


interface IAnswerOptionProps {
  options: Array<string>;
  title: string;
  is_multiselect: boolean;
  lecture_id: number;
  poll_id: number;
}

interface IAnswerOptionState {
  numberOfOptions: number;
  options: Array<string>;
}

class AnswerOption extends React.Component <IAnswerOptionProps, IAnswerOptionState> {
  answers = [];
  constructor(props) {
    super(props);
    this.answers = new Array(props.options.length).fill(false);
    console.log(this.answers);
    this.state = {numberOfOptions: props.options.length, options: props.options};
  }

  render() {
    const allOptions = this.renderAnswers();
    return (
      <React.Fragment>
        <form onSubmit={this.submitAnswers}>
          <h1>{this.props.title}</h1>
          {allOptions}

          <div className="actions">
            <button type="submit" className="btn btn-primary">
              <label>Save Answers</label>
            </button>
          </div>

        </form>
      </React.Fragment>
    );
  }

  renderAnswers() {
    const {is_multiselect} = this.props;
    const {options} = this.state;
    const boxType = is_multiselect ? "checkbox" : "radio";
    const optionElements = [];
    for (let index = 1; index <= options.length; index++){
      const option_name = is_multiselect ? `poll[option_${index}]` : "poll["
      const currentOption =
          <React.Fragment key={`frag_${index}`}>
            <br key={`br_${index}`}/>
            <input id={`poll_option_${index}`} name={"poll[option]"} type={boxType} key={`${index}`} onChange={(evt: ChangeEvent<HTMLInputElement>) => this.handleOptionChange(index,evt.target.checked)}/>
            <label key={`option_${index}_label`}> {index}. {options[index]} {" "} </label>
          </React.Fragment>;
      optionElements.push(currentOption);
    }
    return optionElements;
  }

  // Use anonymous methods so it is automatically bound to this.
  submitAnswers = (event) =>{
    event.preventDefault();
    const data = new FormData(event.target);
    const {lecture_id, poll_id} = this.props;
    data.set("lecture_id", `${lecture_id}`);
    data.set("id", `${poll_id}`);
    data.set("answers", `${this.answers}`);
    const csrf_token: HTMLMetaElement = document.head.querySelector("[name=csrf-token]");
    const headers = new Headers({'C-CSRF-Token': csrf_token.content});
    fetch(`/lectures/${lecture_id}/polls/${poll_id}/save_answers`, {method: "PUT", headers , body: data})
  }

  handleOptionChange = (option_id: number, is_selected: boolean) =>{
    this.answers[option_id-1] = is_selected;
  }
}

export default AnswerOption
