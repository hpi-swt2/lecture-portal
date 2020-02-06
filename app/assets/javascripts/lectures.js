// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on("turbolinks:load", function() {
  if (document.URL.match("#")) {
    $('.nav-tabs a[href="#' + document.URL.split("#")[1] + '"]').tab("show");
  }
});

function initLectureStatusUpdating(isRelevantLectureStatusUpdated) {
  App.cable.subscriptions.create(
    { channel: "LectureStatusChannel" },
    {
      received: function(data) {
        if (isRelevantLectureStatusUpdated(data.lecture_id, data.course_id)) {
          window.location.reload();
        }
      }
    }
  );
}
