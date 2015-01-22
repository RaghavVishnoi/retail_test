$(document).on('ready page:load', function() {
  $('select').select2({
    allowClear: true,
    width: 'resolve'
  });
})

function insert_selected_option(val, name, select) {
  var $option = $('<option selected="selected"></option>').text(name).attr('value', val)
  $(select).append($option).trigger('change');
}
