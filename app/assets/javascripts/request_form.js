var is_rsp_fields = '#request_rsp_name, #request_rsp_mobile_number, #request_rsp_app_user_id'

$(document).on('click', '#next, #back', function(event) {
  event.preventDefault();
  if(!is_next($(this)) || validate_form()) {    
    $(current_page() + '.page').addClass('hidden');
    var page_index = current_page_index();
    var next_page_index = is_next($(this)) ? ++page_index : --page_index;
    set_current_page_index(next_page_index);
    $(current_page() + '.page').removeClass('hidden');
    $('.req_type .select').trigger('click');
    $('.reqstr_detail .selected').removeClass('selected');
    $('.reqstr_detail ' + current_page()).addClass('selected');
    $('#next, #back').removeClass('hidden');
    $('.req_type').hide();
    if(current_page_index() == total_pages() - 1) {
      $('#next').addClass('hidden');
    }
    if(current_page_index() == 0) {
      $('#back').addClass('hidden');
      $('#next').removeClass('hidden');
      $('.request_wrap').addClass('hidden');
    }
    if(current_page() == '.requestor_details_page') {
      $('.request_wrap').removeClass('hidden');
      $('.req_type').show();
    }
  }
});


$(document).on('click', '.req_type a', function() {
  var request_type = $(this).data('request-type');
  $('#request_request_type').val(request_type);
  $('.request_type_field').addClass('hidden');
  $('.' + request_type + '_request_type').removeClass('hidden');
  $('.req_type .select').removeClass('select');
  $(this).addClass('select');
  $('.requstr_main .selected').removeClass('selected');
  $('.requstr_main .' + request_type).addClass('selected');
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

function is_next(element) {
  return $(element).attr('id') == 'next';
}

$(document).on('click', '#request_is_rsp_true', function(event) {
  event.preventDefault();
  $('#request_is_rsp').val(true);
  $('#request_rsp_not_present_reason').val(null).addClass('hidden');
  $(is_rsp_fields).attr('disabled', false);
  $('#next').trigger('click');
});

$(document).on('click', '#request_is_rsp_false', function(event) {
  event.preventDefault();
  $('#request_is_rsp').val(false);
  $(is_rsp_fields).attr('disabled', true).val(null).each(remove_error);
  $('#request_rsp_not_present_reason').removeClass('hidden');
  $('#next').removeClass('hidden');
});

$(document).on('submit', '.request-form', function(event) {
  return validate_form();
});


$(document).on('blur', '.page:visible input, .page:visible select', remove_error);

function remove_error() {
  var $error_container = $(this).closest('.field_with_errors')
  var field = $error_container.find('input[name], select[name]').first()
  if(validate_field(field) || field.attr('disabled')) {
    $error_container.removeClass('field_with_errors');
  }
}

function validate_form() {
  var validate = true;
  $('.page:visible input[name]:visible:enabled, .page:visible select[name]:visible:enabled').each(function() {
    if(($(this).closest('.required').length > 0) && !validate_field($(this))) {
      if(!$(this).closest('.field_with_errors').length) {
        var error_class = $(this).attr('error_container');
        var $error_container = error_class ? $(this).closest(error_class) : $(this);
        $error_container.wrap('<div class="field_with_errors"></div>');
      }
      validate = false;
    }
  });
  return validate;

}

function validate_field(element) {
  var valid, val;
  valid = val = $(element).val();
  var validation = $(element).attr('validation');
  if(validation == "validate_mobile_number") {
    valid = valid && validate_mobile_number(val);
  }
  return valid;
}

function validate_mobile_number(val) {
  return val.match(/^\d{10}$/);
}


$(document).on('ready page:load', function() {
  setTimeout(hide_flash_message, 5000);
});

function hide_flash_message() {
  $('#notice').slideUp(1000);
}