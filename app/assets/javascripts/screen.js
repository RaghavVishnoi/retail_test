$(document).on('submit', '#screen-form', function() {
  $(this).find('.hidden.container').remove();
});

$(document).on('click', '.generate-element-id', function() {
  var unique_key = generate_unique_key();
  var $container = $(this).closest('.container');
  var $element_id = $container.find('.element-id').first();
  var $element_id_field = $container.find('.element-id-field').first();
  $element_id.text(unique_key);
  $element_id_field.val(unique_key);
});