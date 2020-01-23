import ActionCable from "actioncable";

const CableApp = {
    cable: ActionCable.createConsumer(`/cable`)
};

export const setupPollOptionsActionCable = (poll_id, poll_options) => {
    CableApp.cable.subscriptions.create(
        { channel: "PollOptionsChannel", poll_id: poll_id },
        {
            received: data => {
                poll_options(data)
            }
        }
    );
};