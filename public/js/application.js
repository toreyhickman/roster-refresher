var cohortFormHelper = {
  getForm: function() {
    request = $.get('/cohorts').done(this.displayForm).fail(this.displayCohortsError)
  },

  submitForm: function(submit_event) {
    submit_event.preventDefault();

    cohortFormHelper.displayUpdatingWorksheet();

    url = $(this).attr("action");
    data = $(this).serialize();

    $.post(url, data, "json").done(cohortFormHelper.displayWorkSheetUpdateSuccess).fail(cohortFormHelper.displayWorkSheetUpdateError)
  },

  displayUpdatingWorksheet: function(){
    $("#instructions").hide()
    $(".form_wrapper").html(this.updatingWorksheetMessage);
  },

  displayWorkSheetUpdateSuccess: function(){
    $(".form_wrapper").html(cohortFormHelper.worksheetUpdateSuccessMessage);
    cohortFormHelper.redirectToForm();

  },

  displayWorkSheetUpdateError: function() {
    $(".form_wrapper").html(cohortFormHelper.worksheetUpdateErrorMessage);
    cohortFormHelper.redirectToForm();
  },

  redirectToForm: function() {
    setTimeout(function() {
      location.replace("/");
    }, 4000)
  },

  displayForm: function(html_string) {
    $(".form_wrapper").html(html_string);
  },

  displayCohortsError: function() {
    $(".form_wrapper").html(cohortFormHelper.getCohortsErrorMessage);
  },

  getCohortsErrorMessage: "<p class='error'>Sorry, something's gone wrong with retrieving the list of cohorts.</p>",

  updatingWorksheetMessage: "<p class='alert_async'>Updating rosters ...</p>",

  worksheetUpdateSuccessMessage: "<p>Rosters have been updated successfully.</p>",

  worksheetUpdateErrorMessage: "<p class='error'>Sorry, something went wrong. Please be sure to select a cohort.</p>"
}

$(document).ready(function() {

  if ($(".form_wrapper").length) {
    cohortFormHelper.getForm();
  }

  $(".container").on("submit", "#cohort_list_form", cohortFormHelper.submitForm)

});
