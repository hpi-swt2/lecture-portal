import * as React from "react"


interface IPollOptionProps {
  numberOfOptions: React.ReactNode;
}

interface IPollOptionState {
}

class PollOption extends React.Component <IPollOptionProps, IPollOptionState> {
  render() {
    return <React.Fragment>

      <div className="field">
        <text>Number of Options </text>
        <input name="number_of_options" type = "number" onBlur={this.onBlur.bind(this)} />
      </div>
    </React.Fragment>
    ;
  }

  onBlur(){
    alert("i was changed")
  }
}

export default PollOption
