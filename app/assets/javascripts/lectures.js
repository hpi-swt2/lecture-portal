// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

console.log(document.URL);
$(document).on('turbolinks:load', function() {
  if (document.URL.match("#")) {
      console.log(document.URL);
    $('.nav-tabs a[href="#' + document.URL.split("#")[1] + '"]').tab("show");
  }
});