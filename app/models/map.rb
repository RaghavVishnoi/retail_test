class Map < ActiveRecord::Base
  REQUEST_STATUS = ['All', 'CMO Pending', 'CMO Declined', 'Pending', 'Approved', 'Declined']
  REQUEST_TYPE = ['All','GSB','In-shop','SIS','Maintenance','Audit']
  STORE_SIZE = ['0-10','10-20','20-30','30-40','40-50']
  GIONEE_SALES = ['10-50K','50K-1Lac','1Lac-5Lac','5Lac-10Lac','More than 10Lac']
  
  belongs_to :images
  belongs_to :requests

  validate :status

  def self.image_data(params)
      @from = params[:from_date].to_s
      @to = params[:till_date].to_s
      @state = params[:state]
      
      if @from == '0' && @to == '0'
        @to = Time.now.to_date.to_s
        @from = (Time.now - 1.month).to_date.to_s
      end

      if @state.include?('All State')
        @states = State.all.pluck(:id)
      else
        @states = @state.map!(&:to_i)
      end
      states = @states.join(',')
      
      @request_type = params[:request_type]
      @status = params[:status_type]
      if @status == nil || @status.join(',') == 'all'
        status = ['cmo_pending','cmo_declined','pending','approved','declined']
      else
        status = @status
      end
      status = status.flatten.map {|v| "\"#{v.to_s.gsub('"', '""')}\"" }.join(',')

          @request_type = @request_type.map!(&:to_i)  
          request_type = @request_type.join(',')
          @from_date = Time.parse(@from).to_date.beginning_of_day
          @till_date = Time.parse(@to).to_date.end_of_day
          
          sql = "select rq.request_type,rq.status,rq.state,im.lat,im.long,rq.id from  requests as rq JOIN  images as im ON rq.id= im.imageable_id where  rq.state_id IN (#{states}) AND  rq.created_at  BETWEEN '#{@from_date}' AND '#{@till_date}' AND rq.request_type IN(#{request_type}) AND rq.status  IN(#{status}) ;" 
          response = ActiveRecord::Base.connection.execute(sql)
          
          response            
  end
end
