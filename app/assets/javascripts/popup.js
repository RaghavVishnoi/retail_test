function show_popup() {
  $('#popup').removeClass('hidden');
  $('#popup').dialog({ modal: true, height: 300, width: 700 });
}

function create_popup(html) {
  $('#popup').html(html);
  show_popup();
}

function close_popup() {
  $('#popup').addClass('hidden');
  $('#popup').dialog('close')
}

function remove_popup() {
  $('#popup').html('')
  close_popup();
}

$(document).on('click', '.show-details', function() {
  create_popup($(this).closest('tr').find('.details').clone().removeClass('hidden'));
});