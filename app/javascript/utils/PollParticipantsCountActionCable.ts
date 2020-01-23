import ActionCable from "actioncable";

const CableApp = {
    cable: ActionCable.createConsumer(`/cable`)
};

export const setupPollParticipantsCountActionCable = (poll_id, participants_count) => {
    CableApp.cable.subscriptions.create(
        { channel: "PollParticipantsCountChannel", poll_id: poll_id },
        {
            received: data => {
                participants_count(data)
            }
        }
    );
};