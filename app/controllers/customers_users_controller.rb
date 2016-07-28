class CustomersUsersController < ApplicationController

  before_action :initialize_customer_user, :only => :create
  before_action :find_customer_user, :only => [:destroy]
  authorize_resource

  def new
    @customers_user = CustomersUser.new :customer_id => params[:customer_id]
  end

  def create
    if @customers_user.save
      redirect_to customers_path
    else
      render :new
    end
  end

  def destroy
    @customers_user.destroy
    redirect_to customers_path
  end

  private
    def customer_user_params
      params.require(:customers_user).permit(:customer_id, :user_id)
    end

    def initialize_customer_user
      @customers_user = CustomersUser.new customer_user_params
    end

    def find_customer_user
      @customers_user = CustomersUser.where(:id => params[:id]).first
      unless @customers_user
        redirect_to customers_path
      end
    end
end