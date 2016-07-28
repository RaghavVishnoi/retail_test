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
      $('#next').hide();
      $('.apprv_btn').addClass('hidden');
       
    }

    if(current_page_index() == 0) {
      $('#back').addClass('hidden');
      $('.request_wrap').addClass('hidden');
      $('#visitor').hide();
      $('#next').hide();
      $('#maintenance').hide(); 

       
    }

    if(current_page() == '.requestor_details_page') {
      $('.request_wrap').removeClass('hidden');
      $('.req_type').show();

    }
     
    

  }
});
    var rsp = 0,sis = 0,gsb = 0,click = '',click1 = '',clipon= 0;
   $(document).ready(function(){
      $('.apprv_btn').click(function(){
        click = 'next';
        click1 = '';
         
    });
    $('.decline_btn').click(function(){
       click1 = 'back';
       click = ''; 
    });
   
  });
   
$(document).on('click', '#next-v, #back-v', function(event) {
  event.preventDefault();
    
   var status = ''; 
 if(!is_next_v($(this)) || validate_form()) {    
      $('#next-v').click(function(){
        click = 'next';
        click1 = '';
         
    });
      $('.decline_btn').click(function(){
       click1 = 'back';
       click = ''; 
    });
    
    $(current_page1() + '.page').addClass('hidden');
    var page_index = current_page_index1();

    
    $("#is_rsp").change(function () {
      var rsp_value = $("#is_rsp").val();
      if(rsp_value == 'true'){
        rsp = 1;
      }else{
        rsp = 0;
      }
       
    });

    $("#is_gsb").change(function () {
      var gsb_value = $("#is_gsb").val();
      if(gsb_value == 'true'){
        gsb = 1;
      }else{
        gsb = 0;
      }
       
    });

    $("#is_sis").change(function () {
      var sis_value = $("#is_sis").val();
      if(sis_value == 'true'){
        sis = 1;
      }else{
        sis = 0;
      }
       
    });

    $("#is_clipon").change(function () {
      var clipon_value = $("#is_clipon").val();
      if(clipon_value == 'Yes'){
        clipon = 1;
      }else{
        clipon = 0;
      }
       
    });
    
   
    // $("input[id=is_gionee_gsb_present]:radio").change(function () {
  
    //   gsb = 1;
         
    // });
    // $("input[id=not_gionee_gsb_present]:radio").change(function () {
  
    //   gsb = 0;
         
    // });
    
    // $("input[id=is_sis_installed]:radio").change(function () {
  
    //   sis = 1;
         
    // });
    // $("input[id=not_sis_installed]:radio").change(function () {
  
    //   sis = 0;
         
    // });

    // $("input[id=is_clipon]:radio").change(function () {
  
    //   clipon = 1;
         
    // });
    // $("input[id=not_clipon]:radio").change(function () {
  
    //   clipon = 0;
         
    // });
     
    if(page_index == 2 && rsp == 0 && click == 'next'){
      page_index = 3;
    }
     
    if(page_index == 3 && gsb == 0 && click == 'next'){
      page_index = 4;
    }
     
    if(page_index == 4 && sis == 0 && click == 'next'){
      
      page_index = 5;
    }

    if(page_index == 5 && clipon == 0 && click == 'next'){
      
      page_index = 6;
    }

      
  
    if(clipon == 0 && click1 == 'back'){
      if(page_index == 7 && sis != 0){
          page_index = 6;
          status ='updated';
        }else if(page_index == 7 && sis == 0 && gsb!=0){
          page_index = 5;
          status ='updated';
        }else if(page_index == 7 && sis == 0 && gsb == 0 && rsp!=0){
          page_index = 4;
         status ='updated';
        }else if(page_index == 7 && sis == 0 && gsb == 0 && rsp==0){
          page_index = 3;
         status ='updated';
        }  
    }
      if(sis == 0 && status == '' && click1 == 'back'){
         
         if(page_index == 7 && gsb != 0){
          page_index = 5;
          status ='updated'; 
        }else if(page_index == 7 && gsb == 0 && rsp!=0){
          page_index = 4;
          status ='updated';
        }else if(page_index == 7 && gsb == 0 && rsp == 0){
          page_index = 3;
          status ='updated';
        }else if(page_index == 6 && gsb != 0){
          page_index = 5;
          status ='updated';
        }else if(page_index == 6 && gsb == 0 && rsp!=0){
          page_index = 4;
          status ='updated';
        }else if(page_index == 6 && gsb == 0 && rsp == 0){
          page_index = 3;
          status ='updated';
        }  
      }
       
      if(gsb == 0 && status != 'updated' && click1 == 'back'){
        if(page_index == 4 && rsp == 0){
          page_index = 3;
          status ='updated';
           
        }else if(page_index == 5 & rsp == 0){
          page_index = 3;
          status ='updated';
        } 
        else if(page_index == 6 && rsp == 0){
          page_index = 3;
          status ='updated';
        } 
        else if(page_index == 6 && rsp != 0){
          page_index = 4;
          status ='updated';
        } 
        else if(page_index == 5 && rsp != 0){
          page_index = 4;
          status ='updated';
        } 
         
      }
      
     if(rsp == 0 && status != 'updated' && click1 == 'back'){ 
        if(page_index == 4){
          page_index = 3;
          status ='updated';
           
        }else if(page_index == 5 && gsb == 0){
          page_index = 3;
          status ='updated';
           
        }else if(page_index == 6 && gsb == 0 && sis == 0){
          page_index = 3;
          status ='updated';
        } 
  }
 
        
    
      
    
    var next_page_index = is_next_v($(this)) ? ++page_index : --page_index;
    

  
    set_current_page_index1(next_page_index);
    $(current_page1() + '.page').removeClass('hidden');
    $('.req_type .select').trigger('click');
    $('.visitor_detail .selected').removeClass('selected');
    $('.visitor_detail ' + current_page1()).addClass('selected');
    $('#next-v, #back-v').removeClass('hidden');
    $('.req_type').hide();
    if(current_page_index1() == total_pages1() - 1) {
      $('#next-v').addClass('hidden');
    }
    if(current_page_index1() == 0) {
      $('#back-v').addClass('hidden');
      $('#next-v').removeClass('hidden');
      $('.request_wrap').addClass('hidden');
      

    }
    if(current_page1() == '.visitor_details_page') {
      $('.request_wrap').removeClass('hidden');
      $('.req_type').show();
    }
     if(current_page_index1() == -1) {
        $('#visitor').hide();
        $('.request-form').removeClass('hidden');
        $('.request_wrap').addClass('hidden');
    } 

  }
});
$(document).ready(function () {
 $("#rsp_assign").change(function () {
  
     var val = $('#rsp_assign').val();
     if(val == 'Yes'){
      $("#rsp_assigned_in_store").show();
     }
     else{
       $("#rsp_assigned_in_store").hide();
     }
         
         
    });

 $("#clipon_visible").change(function () {
  
     var val = $('#clipon_visible').val();
     if(val == 'Yes'){
      $("#clipon_visible_in_store").show();
     }
     else{
       $("#clipon_visible_in_store").hide();
     }
         
         
    }); 
  
});

$(document).ready(function(){

   $("#maintenance").hide();
   $("#visitor").hide();
   $('#rsp_assigned_in_store').hide();
   $('#clipon_visible_in_store').hide();

});
var request_type = '';
$(document).on('click', '.req_type a', function() {

  request_type = $(this).data('request-type');
   if(request_type == 'maintenance'){
     $("#requestor").hide();
     $("#visitor").hide();
     $("#maintenance").show();
     $('#rsp_name').prop('disabled', true); 
     $('#rsp_mobile').prop('disabled', true); 
     $('#rsp_id').prop('disabled', true); 
     $('#request_type').val('maintenance');
   }
   else if(request_type == 'visitor'){
     $('#request_type').val('visitor');
     $("#visitor").show();
     $("#maintenance").hide();
     $("#requestor").hide();
    
    
   }
   else{
     $("#requestor").show();
     $("#maintenance").hide();
     $("#visitor").hide();
     $('#request_request_type').val(request_type);
   }
  
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



function current_page1() {

  return $('.request-form1').data('pages')[current_page_index1()];
}

function current_page_index1() {
  return $('.request-form1').data('current-page');
}

function set_current_page_index1(page) {
  $('.request-form1').data('current-page', page);
}

function total_pages1() {
  return $('.request-form1').data('pages').length;
}
function is_next_v(element) {
  return $(element).attr('id') == 'next-v';
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
  $('#next').show();
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
  if($(element).attr('type') == 'checkbox') {
    valid = $("[name='" + $(element).attr('name') + "']").filter(':checked').length
  }
 if($(element).attr('type') == 'radio') {
    valid = $("[name='" + $(element).attr('name') + "']").filter(':checked').length
  }
 
   else {
    valid = val = $(element).val();
  }
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

$(document).on('ready page:load', function() {
  $('.img_link').colorbox({ maxWidth:'95%', maxHeight:'95%', rel: 'group' })
});