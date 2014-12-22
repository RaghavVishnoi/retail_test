class AddressesController < ApplicationController
  before_action :set_address, :only => [:edit, :update, :destroy]

  def index
    @addresses = Address.branch_offices
  end
  
  def new
    @address = Address.new
  end

  def create
    @address = Address.new address_params
    if @address.save
      redirect_to addresses_url
    else
      render :new
    end
  end

  def edit
  end

  def edit_hq
    @address = Address.hq
  end

  def update
    if @address.update_attributes address_params
      redirect_to addresses_url
    else
      render :edit
    end
  end

  def destroy
    @address.destroy
    redirect_to addresses_url
  end

  private
    def set_address
      @address = Address.where(:id => params[:id]).first
      unless @address
        redirect_to organization_edit_url, :alert => "Address not found"
      end
    end

    def address_params
      params.require(:address).permit(:address, :city, :state, :country)
    end
end