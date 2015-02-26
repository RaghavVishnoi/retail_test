$(document).on('click', '.add-field', function() {

  var $parent_container = $(this).closest('.container');

  var template_class = $(this).data('templateClass');
  var template_selector = '.' + template_class;
  var $template = $(template_selector).first().clone();
  var unique_key = generate_unique_key();
  $template.appendTo($parent_container);

  $template.find('[name*=key]').each(function() {
    var input_name = [$(this).data('name')];
    $(this).parents('.container').each(function() {
      var data_name = $(this).data("name")
      if(data_name != undefined) {
        data_name = data_name.replace(/key/, unique_key);
        $(this).data('name', data_name);
        input_name.push(data_name);
      }
    });
    input_name = input_name.reverse().join('');
    $(this).attr('name', input_name);
  });
  
  generate_element_id($template);
  
  $template.removeClass('hidden');
  $template.removeClass(template_class);
});

$(document).on('click', '.remove-field', function() {
  $(this).closest('.container').remove();
});


function generate_unique_key() {
  var date = new Date();
  return date.getTime();
}

function generate_element_id(element) {
  var unique_key = generate_unique_key();
  var $container = element.closest('.container');
  var $element_id = $container.find('.element-id').first();
  var $element_id_field = $container.find('.element-id-field').first();
  $element_id.text(unique_key);
  $element_id_field.val(unique_key);
}