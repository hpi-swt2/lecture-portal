import ActionCable from "actioncable";

const CableApp = {
    cable: ActionCable.createConsumer(`/cable`)
};

export const setupStudentsActionCable = (lecture_id, studentJoined, studentLeft) => {
    CableApp.cable.subscriptions.create(
        { channel: "StudentsStatisticsChannel", lecture_id: lecture_id },
        {
            received: data => {
                if(data == 1)
                    studentJoined();
                else if(data == -1)
                    studentLeft();
            }
        }
    );
};