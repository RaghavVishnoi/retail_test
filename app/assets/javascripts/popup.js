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
 $(document).ready(function() {



        $("#request-close").click(function ()
            {
              $('#popup-request').hide();
            });
        $("#errorMessageClose").click(function ()
            {
              $('#error-popup').hide();
            });
        $("#retailerClose").click(function ()
            {
              $('#confirmation-popup').hide();
                 
            });
        
        $('#popup-button').click(function() {
          if($('#popup-button').val() == 'Yes'){
             $('#popup-request').hide();
             $('#popup-request-assignment').show();
          }
          
            
        }); 
        $("#btnClose").click(function (e)
            {
                 $('#popup-request').hide();
                 
            });
      
         $("#btnClose-assignment").click(function (e)
            {
              $('#popup-request-assignment').hide();
            });

         $("#request-csv-close").click(function(){
              $('#csv-request').hide();
         });
         


        
    });

 