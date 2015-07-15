$(document).ready(function(){
           $('#loader').hide();
           $(document).ajaxStart(function () {
             $("#loader").show();
             }).ajaxStop(function () {
             $("#loader").hide();
         });

           $('#get').change(function(){
            $('#city').empty();
             
                               
           	var value = $( "#get option:selected" ).val();

            $.ajax({
                 url: "/requests/state",   
                type: "GET",
                data: { value : value}, 
                dataType: 'text',
                 
                complete: function() {

                },

                success: function(data, textStatus, xhr) {
                  
                  var response = JSON.parse(data);
                  var object = response.requests;
                  var arr = [""]; 
                  

                  for (var key in response.requests) {


                     arr[key] = object[key].city;
                     
                  }
                   
                  var select = document.getElementById("city"); 
                   
                   arr = arr.filter( function( item, index, inputArray ) {
                   return inputArray.indexOf(item) == index;
                    
                 });
                    var el1 = document.createElement("option");
                    el1.textContent = "Select City";
                    el1.value = "";
                    el1.selected = 'true';
                    el1.disabled = 'true';
                    select.appendChild(el1);
                  for(var i in arr){
                    console.log(arr[i])
                    var opt = arr[i];
                    var el = document.createElement("option");
                    el.textContent = opt;
                    el.value = opt;
                    select.appendChild(el);
                  }
                        
                       
                      },
                error: function() {
                         alert("Ajax error!")
                      }
    });	
          

           });



        $('#city').change(function(){
            $('#retailer').empty();
             
                               
            var value = $( "#city option:selected" ).val();
            $.ajax({
                 url: "/requests/city",   
                type: "GET",
                data: { value : value}, 
                dataType: 'text',
                complete: function() {},
                success: function(data, textStatus, xhr) {
                
                  var response = JSON.parse(data);
                  var object = response.requests;
                  var arr = [""]; 
                  var arr1 = [""];
                  var name = [""];
                  for (var key in response.requests) {

                     arr[key] = object[key].retailer_code;
                     name[key] = object[key].retailer_name;

                      
                  }

                  var select = document.getElementById("retailer"); 
                   
                   arr = arr.filter( function( item, index, inputArray ) {
                   return inputArray.indexOf(item) == index;
                 });
                    
                    var el1 = document.createElement("option");
                    el1.textContent = "Select Retailer Code";
                    el1.value = "";
                    el1.selected = 'true';
                    el1.disabled = 'true';
                    select.appendChild(el1);
                  for(var i in arr){
                    var opt = arr[i];
                    var el = document.createElement("option");
                    el.textContent = opt+' - '+name[i];
                    el.value = opt;
                    select.appendChild(el);
                  }
                        
                       
                      },
                error: function() {
                         alert("Ajax error!")
                      }
    }); 

           });
   

       });