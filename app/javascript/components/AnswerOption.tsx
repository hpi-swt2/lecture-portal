import * as React from "react";
import { ChangeEvent } from "react";
import * as axios from "axios";

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

class AnswerOption extends React.Component<
  IAnswerOptionProps,
  IAnswerOptionState
> {
  answers = [];
  constructor(props) {
    super(props);
    this.answers = new Array(props.options.length).fill(false);
    console.log(this.answers);
    this.state = {
      numberOfOptions: props.options.length,
      options: props.options
    };
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
    const { is_multiselect } = this.props;
    const { options } = this.state;
    const boxType = is_multiselect ? "checkbox" : "radio";
    const optionElements = [];
    for (let index = 1; index <= options.length; index++) {
      const option_name = is_multiselect ? `poll[option_${index}]` : "poll[";
      const currentOption = (
        <React.Fragment key={`frag_${index}`}>
          <br key={`br_${index}`} />
          <input
            id={`poll_option_${index}`}
            name={"poll[option]"}
            type={boxType}
            key={`${index}`}
            onChange={(evt: ChangeEvent<HTMLInputElement>) =>
              this.handleOptionChange(index, evt.target.checked)
            }
          />
          <label key={`option_${index}_label`}>
            {index}. {options[index]}{" "}
          </label>
        </React.Fragment>
      );
      optionElements.push(currentOption);
    }
    return optionElements;
  }

  // Use anonymous methods so it is automatically bound to this.
  submitAnswers = async event => {
    event.preventDefault();
    const { lecture_id, poll_id } = this.props;
    const outerFormForSubmit = document.getElementById("outer-form");
    const authenticity_token_elem: HTMLInputElement = outerFormForSubmit.querySelector(
      "[name=authenticity_token]"
    );
    const authenticity_token = authenticity_token_elem.value;
    const data = {
      authenticity_token,
      lecture_id,
      id: poll_id,
      answers: this.answers
    };
    const response = await axios.post(
      `/lectures/${lecture_id}/polls/${poll_id}/save_answers`,
      data
    );
    const newUrl = response.request.responseURL;
    window.location.href = newUrl;
  };

  handleOptionChange = (option_id: number, is_selected: boolean) => {
    this.answers[option_id - 1] = is_selected;
  };
}

export default AnswerOption;
