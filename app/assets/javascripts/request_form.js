$(document).on('click', '#next', function() {
  var current_request_details = $('.request-details:visible');
  var next_request_details = current_request_details.next('.request-details');
  if(next_request_details.length > 0) {
    current_request_details.addClass('hidden');
    next_request_details.removeClass('hidden');
  } else {
    $('.request-form').submit();
  }
});

$(document).on('click', '.req_type a', function() {
  var request_type = $(this).data('request-type');
  $('#request_request_type').val(request_type);
  $('.' + request_type + '_request_type').removeClass('hidden');
  $('.req_type .select').removeClass('select');
  $('.req_type .' + request_type).addClass('select');
})