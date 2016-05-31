class ShopAssignmentsController < ApplicationController
	
	skip_before_action :verify_authenticity_token
	authorize_resource
	PERPAGE = 50

	def index
		session[:prev_url] = request.fullpath
		@shop_assignments = ShopAssignment.assignments(params,current_user).paginate(:per_page => PERPAGE,:page => (params[:page] || 1))
	end

	def new
		session[:prev_url] = request.fullpath
		@assignments = ShopAssignment.available_assignment(current_user,params[:state],params[:city]).paginate(:per_page => PERPAGE,:page => (params[:page] || 1))
		@shop_assignment = ShopAssignment.new
	end

	def create
		@shop_assignment = ShopAssignment.create shop_assignment_params
		if @shop_assignment
			render :json => true
		else
			render :json => false
		end
	end

	def edit
		@assignment = shop_assignment
	end

	def update
		@assignment = shop_assignment.update(user_id: params[:shop_assignment][:user_id])
		if @assignment
			render :json => {result: true}
		else
			render :json => {result: false}
		end
	end

	def search
		@assignments = ShopAssignment.search(params[:from],params[:to],params[:status],params[:user_id])
		render :json => @assignments
	end

	def shop_assignment_params
		params.require(:shop_assignment).permit(:user_id,{:retailer_id => []},:assign_date)
	end

  private
	def shop_assignment
		ShopAssignment.find(params[:id])
	end

end