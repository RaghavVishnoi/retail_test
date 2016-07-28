module Api
  module V1
    class ShopAssignmentsController < BaseController
      skip_authorize_resource
      set_pagination_headers :shop_assignments, only: [:index] 

      def index
         page = {}
         page[:page] = params[:page]
       	 @shop_assignments = assignments.paginate(page).per_page(10) 
         render :index
      end

      def audited
       	@assignment = ShopAssignment.find(params[:id]).update_attributes(params.require(:shop_assignment).permit(:request_id,:status))
      	if @assignment
      		render :json => {result: true}
      	else
      		render :json => {result: false}
      	end
      end

      def create
        @shop_assignment = ShopAssignment.new(shop_assignment_params.
                                              merge(assign_date: Time.now))
        if @shop_assignment.save
          render :json => {result: true}
        else
          render :json => {result: false,messages:  @shop_assignment.errors.full_messages}
        end
      end

      def shop_assignment_params
        params.require(:shop_assignment).permit(:user_id,:request_id,:assignment_type,:status,:retailer_id)
      end

      def assignments
          ShopAssignment.where(user_id: User.find_by(auth_token: params[:auth_token]).id,status: params[:status])
      end

  	end
  end
end
      