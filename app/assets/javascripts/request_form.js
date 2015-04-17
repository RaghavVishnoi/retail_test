$(document).on('click', '#next, #back', function(event) {
  event.preventDefault();
  $(current_page()).addClass('hidden');
  var page_index = current_page_index();
  var next_page_index = ($(this).attr('id') == 'next') ? ++page_index : --page_index;
  set_current_page_index(next_page_index);
  $(current_page()).removeClass('hidden');
  $('.req_type .select').trigger('click');
  $('.reqstr_detail .selected').removeClass('selected');
  $('.reqstr_detail .details').eq(next_page_index).addClass('selected');
  $('#next, #back').removeClass('hidden');
  $('.req_type').hide();
  if(current_page_index() == total_pages() - 1) {
    $('#next').addClass('hidden');
  }
  if(current_page_index() == 0) {
    $('#back').addClass('hidden');
    $('.request_wrap').addClass('hidden');
  }
  if(current_page() == '.requestor_details_page') {
    $('.request_wrap').removeClass('hidden');
    $('.req_type').show();
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

$(document).on('click', '#request_is_rsp', function() {
  if($(this).val() == "true") {
    $('#request_rsp_not_present_reason').addClass('hidden');
    $('#next').trigger('click');
  } else if($(this).val() == "false") {
    $('.request_wrap input, .request_wrap select').val(null);
    $('#request_rsp_not_present_reason').removeClass('hidden');
    $('.rsp_page  input[type="submit"]').removeClass('hidden');
  }
});