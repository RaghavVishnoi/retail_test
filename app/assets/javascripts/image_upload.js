function fileupload(element) {
  $(element).fileupload({
    dataType: 'script'
  });
}

$(document).on('ready page:load', function() {

  $('#dropfile').fileupload({
    dataType: 'script',
    submit: function(e, data) {
      var form_data = $(this).closest('form').serializeArray();
      form_data.push({ name: 'document[name]', value: data.files[0].name })
      data.formData = form_data
    },
    dropZone: $('#dropzone')
  });
});