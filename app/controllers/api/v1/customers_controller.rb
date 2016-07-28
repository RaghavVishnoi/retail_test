module Api
  module V1
    class CustomersController < BaseController

      PER_PAGE = 20

      before_action :initialize_resources, :only => [:index]
      before_action :set_customer, :only => [:show, :update, :destroy, :edit]
      
      def index
        @customers = @customers.paginate(:per_page => PER_PAGE, :page => params[:page] || '1')
        render :json => { result: true, :per_page => @customers.per_page, :length => @customers.length, :current_page => @customers.current_page, :total_pages => @customers.total_pages, :updated_at => Time.current, :customers => @customers.as_json }
      end  

      def new
        @customer = Customer.new
        render :json => { result: true, customer: @customer.as_json, states: ADDRESS_STATES, default_state: current_address_state }
      end

      def edit
        render :json => { result: true, customer: @customer.as_json, states: ADDRESS_STATES }
      end

      def create
        @customer = Customer.new customer_params
        if @customer.save
          render :json => { result: true }
        else
          render :json => { result: false, :errors => { :messages => @customer.errors.full_messages } }
        end
      end 

      def show
        render :json => { result: true, customer: @customer.as_json }
      end

      def update
        if @customer.update_attributes(customer_params)
          render :json => { result: true }
        else
          render :json => { result: false, :errors => { :messages => @customer.errors.full_messages } }
        end
      end

      def destroy
        @customer.destroy
        render :json => { result: true }
      end

      private
        def customer_params
          params.require(:customer).permit(:name, :address, :state, :phone_number, :store_manager, :avatar)
        end

        def set_customer
          @customer = Customer.where(:id => params[:id]).first
          unless @customer
            render :json => { result: false, :errors => { :messages => ["Customer not found"] } }
          end
        end
    end
  end
end