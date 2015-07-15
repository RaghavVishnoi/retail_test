$(document).ready(function(){
	$('#other').hide();
	$('#vendor').hide();
	$('#vendor_verify').change(function(){
			var value = $('#vendor_verify').val();
			 if(value == 'Vendor'){
				$('#vendor').show();
				$('#other').hide();
				$("#other").prop('required', false); 
			}
			else{
				$('#other').show();
				$('#vendor').hide();
				$("#vendor").prop('required', false); 
			}
	        
	});
	

});