import * as React from "react";
import { ChangeEvent } from "react";
import * as axios from "axios";

interface IOption {
  description: string;
  id: number;
}

interface IAnswerOptionProps {
  options: Array<IOption>;
  title: string;
  is_multiselect: boolean;
  lecture_id: number;
  poll_id: number;
  auth_token: string;
  previous_answers: Array<number>;
}

interface IAnswerOptionState {
  answers: Array<IAnswer>;
  showNoOptionSelectedError: boolean;
}

class AnswerOption extends React.Component<
  IAnswerOptionProps,
  IAnswerOptionState
> {
  constructor(props) {
    super(props);
    console.log(props);
    const answers = props.options.map(option => ({
      value: props.previous_answers.includes(option.id),
      id: option.id
    }));
    this.state = {
      showNoOptionSelectedError: false,
      answers
    };
  }

  render() {
    const allOptions = this.renderAnswers();
    return (
      <React.Fragment>
        <form onSubmit={this.submitAnswers}>
          <h1>{this.props.title}</h1>
          {this.state.showNoOptionSelectedError ? (
            <div className="alert alert-danger">
              <h6 className="alert-heading">Please select an answer</h6>
            </div>
          ) : null}
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
    const { is_multiselect, options } = this.props;
    const { answers } = this.state;
    const boxType = is_multiselect ? "checkbox" : "radio";
    const optionElements = [];
    answers.map((answer, index) => {
      const currentOption = (
        <React.Fragment key={`frag_${index}`}>
          <br key={`br_${index}`} />
          <input
            id={`poll_option_${index}`}
            name={"poll[option]"}
            type={boxType}
            checked={answer.value}
            key={`${index}`}
            onChange={(evt: ChangeEvent<HTMLInputElement>) =>
              this.handleOptionChange(index, evt.target.checked)
            }
          />{" "}
          <label key={`option_${index}_label`}>
            {index + 1}. {options[index].description}
          </label>
        </React.Fragment>
      );
      optionElements.push(currentOption);
    });
    return optionElements;
  }

  // Use anonymous methods so it is automatically bound to this.
  submitAnswers = async event => {
    event.preventDefault();
    const { answers } = this.state;
    if (!answers.some(answer => answer.value === true)) {
      this.setState({ showNoOptionSelectedError: true });
      return;
    } else {
      this.setState({ showNoOptionSelectedError: false });
    }
    const { lecture_id, poll_id, auth_token } = this.props;
    const data = {
      authenticity_token: auth_token,
      lecture_id,
      id: poll_id,
      answers
    };
    const response = await axios.post(
      `/lectures/${lecture_id}/polls/${poll_id}/save_answers`,
      data
    );
    const newUrl = response.request.responseURL;
    window.location.href = newUrl;
  };

  handleOptionChange = (option_index: number, is_selected: boolean) => {
    let newAnswers;
    if (!this.props.is_multiselect) {
      newAnswers = this.state.answers.map((answer, index) => ({
        value: option_index === index,
        id: answer.id
      }));
    } else {
      newAnswers = this.state.answers.map((answer, index) => ({
        value: option_index === index ? is_selected : answer.value,
        id: answer.id
      }));
    }
    this.setState({ answers: newAnswers });
  };
}

export default AnswerOption;
