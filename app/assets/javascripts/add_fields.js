$(document).on('click', '.add-field', function() {
  var $parent_container = $(this).closest('.dynamic-fields-container');
  var $fields_container = $parent_container.find('.hidden.fields-container').clone();
  $fields_container.appendTo($parent_container);
  $fields_container.removeClass('hidden');
});

$(document).on('click', '.remove-field', function() {
  $(this).closest('.container').remove();
});
