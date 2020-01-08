import ActionCable from "actioncable";

const CableApp = {
    cable: ActionCable.createConsumer(`/cable`)
};

export const setupPollsActionCable = (lecture_id, pollReceived) => {
    CableApp.cable.subscriptions.create(
        { channel: "PollsChannel", lecture_id: lecture_id },
        {
            received: data => {
                pollReceived(data)
            }
        }
    )
};