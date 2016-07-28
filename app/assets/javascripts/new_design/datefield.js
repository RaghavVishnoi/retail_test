$(document).ready(function(){

	$(".search_button").click(function(){
        if(location.href.indexOf('?') === -1){
            location.href = "/dashboard?from="+$("#date_from").val()+"&to="+$("#date_to").val(); 
        }else{
        var vType =  getUrlVars()["v"]; 
        if(vType.length != 0){
            location.href = "/dashboard?v="+vType+"&from="+$("#date_from").val()+"&to="+$("#date_to").val();
        }else{
            location.href = "/dashboard?from="+$("#date_from").val()+"&to="+$("#date_to").val(); 
        }
        }
        
	});

    $(".request_search_button").click(function(){
        url1 = window.location.href.split('&from=')[0]
        url2 = window.location.href.split('&state=')[1]
        location.href = url1+"&from="+$("#date_from").val()+"&to="+$("#date_to").val()+"&state="+url2
    });

var fromVar = getUrlVars()["from"]; 
var toVar = getUrlVars()["to"];  

    from = urldecode(fromVar);
    to =   urldecode(toVar);
       if( from.length  != 0 && from != "undefined" && to.length  != 0 && to != "undefined")
        {
             $("#date_from").val(from);
             $("#date_to").val(to);            
        }else{
            console.log(current_date())
        	 $("#date_from").val(previous_date(30*86400000));
             $("#date_to").val(current_date());
        }

        

});
    function getUrlVars(){
        var vars = [], hash;
        var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for(var i = 0; i < hashes.length; i++)
        {
            hash = hashes[i].split('=');
            vars.push(hash[0]);
            vars[hash[0]] = hash[1];
        }
        return vars;
    }

    function urldecode(str) {
       return decodeURIComponent((str+'').replace(/\@/g, '%40'));
    }

    function current_date(){
    	var date = new Date();
    	var month;
    	if(date.getMonth() < 10){
    		month = date.getMonth()+1
    		month = "0"+month
    	}else{
    		month = date.getMonth()+1
    	} 
        if(date.getDate() < 10){
            date1 = "0"+date.getDate()
        }else{
            date1 = date.getDate()
        }
		var strDate = date.getFullYear() + "-" + month + "-" + date1;
        return strDate	
    }

    function previous_date(time){
    	//var date = new Date();
    	var pdate = new Date(new Date().getTime() - time)
    	var month;
    	if(pdate.getMonth() < 10){
    		month = pdate.getMonth()+1
    		month = "0"+month
    	}else{
    		month = pdate.getMonth()+1
    	}
        if(pdate.getDate() < 10){
            date1 = "0"+pdate.getDate();
        }else{
            date1 = pdate.getDate();
        } 
		var strDate = pdate.getFullYear() + "-" + month + "-" + date1;
        return strDate	
    }