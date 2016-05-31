class UserAuditsController < ApplicationController
	authorize_resource
	

	def index
		session[:prev_url] = request.fullpath
		@response = UserAudit.audits(current_user,params)
	end

	 
	def show
		@assignments = ShopAssignment.where(user_id: params[:id],created_at: from_date(params[:from]).beginning_of_day..to_date(params[:to]).end_of_day)
		@parent = UserParent.user_parent(params[:id],'auditor')
		@user = User.find(params[:id])
	end

	private
	 def from_date(from)
	 	if @from == nil || @from == ''
	 		Time.now.to_date - 1.month
	 	else	
	 	   @from
	 	end
	 end

	 def to_date(to)
	 	if @to == nil || @to == ''
	 		Time.now.to_date
	 	else
	 		@to
	 	end
	 end

end
