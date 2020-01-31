// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function initLectureStatusUpdating(isRelevantLectureStatusUpdated) {
    App.cable.subscriptions.create(
        {channel: "LectureStatusChannel"},
        {
            received: function (data) {
             if (isRelevantLectureStatusUpdated(data.lecture_id, data.course_id)) {
                window.location.reload()
              }
            }
        } 
    )
}
