class SalesOrdersController < ApplicationController
  before_action :set_sales_order, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user, :except => [:destroy,:index,:show]
  skip_before_action :verify_authenticity_token
  authorize_resource
  skip_authorize_resource :only => [:user_data]
  PER_PAGE = 50

  # GET /sales_orders
  # GET /sales_orders.json
  def index
    @sales_orders = SalesOrder.permit_branding_shops(current_user).paginate(:per_page => PER_PAGE,:page => (params[:page] || 1))
    # sales_order = SalesOrder.find(1)
   end

  # GET /sales_orders/1
  # GET /sales_orders/1.json
  def show
  end

  # GET /sales_orders/new
  def new
    @sales_order = SalesOrder.new
  end

  # GET /sales_orders/1/edit
  def edit
  end

  # POST /sales_orders
  # POST /sales_orders.json
  def create
    @sales_order = SalesOrder.new(sales_order_params)

    respond_to do |format|
      if @sales_order.save
        format.html { redirect_to @sales_order, notice: 'Sales order was successfully created.' }
        format.json { render :show, status: :created, location: @sales_order }
      else
        format.html { render :new }
        format.json { render json: @sales_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales_orders/1
  # PATCH/PUT /sales_orders/1.json
  def update
    respond_to do |format|
      if @sales_order.update(sales_order_params)
        format.html { redirect_to @sales_order, notice: 'Sales order was successfully updated.' }
        format.json { render :show, status: :ok, location: @sales_order }
      else
        format.html { render :edit }
        format.json { render json: @sales_order.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def destroy
    @sales_order.destroy
    respond_to do |format|
      format.html { redirect_to sales_orders_url, notice: 'Sales order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def user_data
    SalesOrder.create(params)
    render :json => {result: true}
  end

  def download_report
     SalesOrder.download(params[:id].to_i)
     @sales =  SalesOrder.find(params[:id].to_i)
     
     path = "/brand_store/brandstoreproposal_"+@sales.id.to_s+".xls"
    
     #puts "dddddd#{path.split('public')[1]}"

     render :json => path
  end

  def change_status
    salesorder = SalesOrder.find(params[:id].to_i)
     if params[:status] == 'accept'
        salesorder.update(status: 'accept',comment: params[:comment])
    else
       salesorder.update(status: 'decline',comment: params[:comment])
    end
    render :json => {result: true,status: status}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_order
      @sales_order = SalesOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    
end
