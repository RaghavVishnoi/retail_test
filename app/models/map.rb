class Map < ActiveRecord::Base


	REQUEST_STATUS = ['All', 'CMO Pending', 'CMO Declined', 'Pending', 'Approved', 'Declined']
	REQUEST_TYPE = ['All','GSB','In-shop','SIS','Maintenance','Audit']
	STORE_SIZE = ['0-10','10-20','20-30','30-40','40-50']
	GIONEE_SALES = ['10-50K','50K-1Lac','1Lac-5Lac','5Lac-10Lac','More than 10Lac']
	belongs_to :images
	belongs_to :requests

	validate :status
	def self.image_data(request_type,status,state,cmo,from,to,store_size,rsp_present,gionee_sales)
		@request_type = '',@status = '',@state = [],@cmo = '',@from = '',@to = '',@store_size = '',@rsp_present = '',@gionee_sales = ''
        if status[:status].include? 'All'
        	@status = ['cmo_pending','cmo_declined','pending','approved','declined']

        else
        	@status = status[:status]
        	(0...@status.length-1).each do |stat|
        		if @status[stat] == 'CMO Pending'
        			@status[stat] = 'cmo_pending'
        		end
        		if @status[stat] == 'CMO Declined'
        			@status[stat] = 'cmo_declined'
        		end
        		if @status[stat] == 'Pending'
        			@status[stat] = 'pending'
        		end
        		if @status[stat] == 'Approved'
        			@status[stat] = 'approved'
        		end
        		if @status[stat] == 'Declined'
        			@status[stat] = 'declined'
        		end
        	end
        end

         if request_type[:request_type].include? 'All'

        	@request_type = [0,1,2,3,4]

         else

        	@request_type = request_type[:request_type]
        	@request_type.delete_at(@request_type.length)
        	 
        	(0..@request_type.length-1).each do |stat|
                puts "request_type #{@request_type[stat]}"
        		if @request_type[stat] == 'GSB'
        			@request_type[stat] = 0
        		end
        		if @request_type[stat] == 'In-shop'
        			@request_type[stat] = 2
        		end
        		if @request_type[stat] == 'SIS'
        			@request_type[stat] = 1
        		end
        		if @request_type[stat] == 'Maintenance'
        			@request_type[stat] = 3
        		end
        		if @request_type[stat] == 'Audit'
        			@request_type[stat] = 4
        		end
        		

        	end
        	 

        end

        if cmo == '' || cmo == nil
            @cmo = CMO.all
        else
            @cmo = cmo
        end

        if state == 'All State'
            @state = Request.all.pluck(:state).uniq
            
        else
            @state = state    
        end

        if gionee_sales == 'Whole Sale'
            @gionee_sales = Request.all.pluck(:avg_gionee_monthly_sales).uniq
        else
            @gionee_sales = gionee_sales
        end

        if rsp_present == 'All'
            rsp_present = [0,1]
        elsif rsp_present == 'true'
            rsp_present = 1
        else
            rsp_present = 0
        end

        if store_size == 'All Size'
            @store_size = Request.all.pluck(:avg_store_monthly_sales).uniq
        else
            @store_size = store_size
        end

        if from == '' || from ==nil || to == '' || to== nil
             puts "#{@status} --- #{@request_type} --- #{@cmo} --- #{@gionee_sales} --- #{@store_size} ---1 #{@state} --- #{}"
             @request = Request.where(:status => @status,:request_type => @request_type,:cmo_id => @cmo,:avg_gionee_monthly_sales => @gionee_sales,:avg_store_monthly_sales => @store_size ,:state => @state,:is_rsp => rsp_present)#.last(50)
              
        else
            @from_date = Time.zone.parse(from) || Time.current
            @till_date = Time.zone.parse(to) || Time.current
            @from_date = @from_date.beginning_of_day
            @till_date = @till_date.end_of_day
            @request = Request.where(:status => @status,:request_type => @request_type,:cmo_id => @cmo,:state => @state,:is_rsp => rsp_present,:avg_gionee_monthly_sales => @gionee_sales,:avg_store_monthly_sales => @store_size ,:created_at => @from_date..@till_date)#.last(50)
        
        end
            
 end
end
