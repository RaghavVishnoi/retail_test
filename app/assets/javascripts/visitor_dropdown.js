$(document).ready(function(){
           $('#loader2').hide();
           $(document).ajaxStart(function () {
             $("#loader2").show();
             }).ajaxStop(function () {
             $("#loader2").hide();
         });

           $('#get2').change(function(){
            $('#city2').empty();
             
                               
           	var value = $( "#get2 option:selected" ).val();

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
                   
                  var select = document.getElementById("city2"); 
                   
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



        $('#city2').change(function(){
            $('#retailer2').empty();
             
                               
            var value = $( "#city2 option:selected" ).val();
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

                  var select = document.getElementById("retailer2"); 
                   
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