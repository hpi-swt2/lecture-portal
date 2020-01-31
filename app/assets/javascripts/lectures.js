// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function() {
    App.cable.subscriptions.create(
        {channel: "LectureStatusChannel"},
        {
            received: function (data) {
              if (typeof isRelevantLectureStatusUpdated === "function" && isRelevantLectureStatusUpdated(data.lecture_id, data.course_id)) {
                window.location.reload()
              }
            }
        } 
      )
  }.call(this));
