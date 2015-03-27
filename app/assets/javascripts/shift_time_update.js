$(document).on('click', '.user_ids_checkbox', function() {
  var $form = $('#update-all-shift-time');
  if($(this).is(':checked')) {
    var $input = $('<input class="hidden"></input>').attr('id', 'user-select-'+$(this).val());
    $input.attr('name', $(this).attr('name'));
    $input.attr('value', $(this).val());
    $form.append($input);
  } else {
    $('#user-select-'+$(this).val()).remove();
  }
});