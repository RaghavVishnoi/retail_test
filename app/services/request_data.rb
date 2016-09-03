class RequestData

	def self.vendor(request)
	    if request.request_assignment != nil 
	       request.request_assignment.user.name 
	    else 
	      nil 
	    end
	  end

	  def self.cmoName(request)
	    if request.state_id != nil 
	     UserState.user(request.state_id,'cmo').join(',') 
	    else 
	      'No CMO' 
	    end
	  end

	  def self.rrmName(request)
	  	if request.state_id != nil 
	     UserState.user(request.state_id,'rrm').join(',') 
	    else 
	      'No CMO' 
	    end
	  end

	  def self.priority(request)
	  	if request.request_assignment != nil
	  		request.request_assignment.priority
	  	else
	  		'Normal'
	  	end
	  end


end

