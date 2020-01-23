import ActionCable from "actioncable";

const CableApp = {
    cable: ActionCable.createConsumer(`/cable`)
};

export const setupQuestionsActionCable = (lecture_id, questionReceived, questionResolved, questionUpvoted = null) => {
    CableApp.cable.subscriptions.create(
        { channel: "QuestionsChannel", lecture_id: lecture_id },
        {
            received: data => {
                questionReceived(data)
            }
        }
    );
    CableApp.cable.subscriptions.create(
        { channel: "QuestionResolvingChannel", lecture_id: lecture_id },
        {
            received: id => {
                questionResolved(id);
            }
        }
    );
    CableApp.cable.subscriptions.create(
        { channel: "QuestionUpvotingChannel", lecture_id: lecture_id },
        {
            received: data => {
                questionUpvoted(data.question_id, data.upvoter_id)
            }
        }
    );
};