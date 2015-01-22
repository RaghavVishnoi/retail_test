function show_popup() {
  $('#popup').show();
}

function create_popup(html) {
  $('#popup').html(html);
  show_popup();
}

function close_popup() {
  $('#popup').hide();
}

function remove_popup() {
  $('#popup').html('')
  close_popup();
}