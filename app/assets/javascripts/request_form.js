$(document).on('click', '#next, #back', function() {
  $(current_page()).addClass('hidden');
  var page_index = current_page_index();
  var next_page_index = ($(this).attr('id') == 'next') ? ++page_index : --page_index;
  set_current_page_index(next_page_index);
  $(current_page()).removeClass('hidden');
  $('.req_type .select').trigger('click');
  $('.reqstr_detail .selected').removeClass('selected');
  $('.reqstr_detail .details').eq(next_page_index).addClass('selected');
  $('#next, #back').show();
  $('.req_type').hide();
  if(current_page_index() == total_pages() - 1) {
    $('#next').hide();
  }
  if(current_page_index() == 0) {
    $('#back').hide();
  }
});


$(document).on('click', '.req_type a', function() {
  var request_type = $(this).data('request-type');
  $('#request_request_type').val(request_type);
  $('.request_type_field').addClass('hidden');
  $('.' + request_type + '_request_type').removeClass('hidden');
  $('.req_type .select').removeClass('select');
  $(this).addClass('select');
});


function current_page() {
  return $('.request-form').data('pages')[current_page_index()];
}

function current_page_index() {
  return $('.request-form').data('current-page');
}

function set_current_page_index(page) {
  $('.request-form').data('current-page', page);
}

function total_pages() {
  return $('.request-form').data('pages').length;
}