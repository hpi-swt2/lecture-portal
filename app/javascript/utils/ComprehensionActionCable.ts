import ActionCable from "actioncable";

const CableApp = {
    cable: ActionCable.createConsumer(`/cable`)
};

export const setupComprehensionActionCable = (lecture_id, updateReceived) => {
    CableApp.cable.subscriptions.create(
        { channel: "ComprehensionStampChannel", lecture_id: lecture_id },
        {
            received: data => {
                updateReceived(data)
            }
        }
    );
};
