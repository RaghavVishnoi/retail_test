class CustomersController < ApplicationController
  
  PER_PAGE = 20

  before_action :find_customer, :only => [:show, :edit, :update]

  def index
    @customers = current_user.customers.paginate(:per_page => PER_PAGE, :page => params[:page] || '1')
    respond_to do |format|
      format.html
      format.json do
        render :json => { result: true, :per_page => @customers.per_page, :length => @customers.length, :current_page => @customers.current_page, :total_pages => @customers.total_pages, :updated_at => Time.current, :customers => ActiveModel::ArraySerializer.new(@customers, :each_serializer => CustomerSerializer) }
      end
    end
  end

  def show
    @customers_users = @customer.customers_users.includes(:user)
  end

  def update
    if @customer.update_attributes customer_params
      respond_to do |format|
        format.html { redirect_to customers_path }
        format.json { render :json => { :result => true, :customer => CustomerSerializer.new(@customer, root: false).as_json } }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json do
          render :json => { :result => false, :errors => { :messages => @customer.errors.full_messages } }
        end
      end
    end
  end

  def autocomplete
    customers = current_user.customers.with_name(params[:q]).pluck(:name, :id)
    render :json => customers, root: false
  end

  def create
    @customer = current_user.customers.create customer_params
    unless @customer.new_record?
      respond_to do |format|
        format.json { render :json => { :result => true, :customer => CustomerSerializer.new(@customer, root: false).as_json } }
      end
    else
      respond_to do |format|
        format.json do 
          render :json => { :result => false, :errors => { :messages => @customer.errors.full_messages } }
        end
      end
    end
  end

  private

    def customer_params
      params.require(:customer).permit(:name, :customer_type, :website, :account_owner, :phone, :industry, :customer_group, :description, :phone1, :phone2, :email1, :email2, :licence_details)
    end
  
    def find_customer
      @customer = current_user.customers.where(:id => params[:id]).first
      unless @customer
        respond_to do |format|
          format.html { redirect_to customers_path }
          format.json do
            render :json => { :result => false, :errors => { :messages => ["Customer not found"] } }
          end
        end
      end
    end

end