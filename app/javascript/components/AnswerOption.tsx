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
}

interface IAnswerOptionState {
  showNoOptionSelectedError: boolean;
}

class AnswerOption extends React.Component<
  IAnswerOptionProps,
  IAnswerOptionState
> {
  answers = [];
  constructor(props) {
    super(props);
    this.answers = props.options.map(option => ({
      value: false,
      id: option.id
    }));
    this.state = {
      showNoOptionSelectedError: false
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
    const boxType = is_multiselect ? "checkbox" : "radio";
    const optionElements = [];
    for (let index = 0; index < options.length; index++) {
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
          />{" "}
          <label key={`option_${index}_label`}>
            {index + 1}. {options[index].description}{" "}
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
    if (!this.answers.some(answer => answer.value === true)) {
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
      answers: this.answers
    };
    const response = await axios.post(
      `/lectures/${lecture_id}/polls/${poll_id}/save_answers`,
      data
    );
    const newUrl = response.request.responseURL;
    window.location.href = newUrl;
  };

  handleOptionChange = (option_index: number, is_selected: boolean) => {
    if (!this.props.is_multiselect) {
      this.answers.forEach(
        (answer, index) => (answer.value = option_index === index)
      );
    } else {
      this.answers[option_index].value = is_selected;
    }
  };
}

export default AnswerOption;
