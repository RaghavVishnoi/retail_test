class ContactsController < ApplicationController
  before_action :set_customer
  before_action :set_contact, :only => [:edit, :update, :destroy]

  def new
    @contact = @customer.contacts.new
  end

  def create
    @contact = @customer.contacts.create contact_params
    unless @contact.new_record?
      respond_to do |format|
        format.html { redirect_to @customer }
        format.json { render :json => { :result => true, :contact => ContactSerializer.new(@contact, root: false).as_json } }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json do
          render :json => { :result => false, :errors => { :messages => @contact.errors.full_messages } }
        end
      end
    end
  end

  def update
    if @contact.update_attributes contact_params
      respond_to do |format|
        format.html { redirect_to @customer }
        format.json { render :json => { :result => true, :contact => ContactSerializer.new(@contact, root: false).as_json} }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json do
          render :json => { :result => false, :errors => { :messages => @contact.errors.full_messages } }
        end
      end
    end
  end

  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to @customer }
      format.json { render :json => { :result => true } }
    end
  end

  private

    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :designation, :phone, :avatar)
    end

    def set_customer
      @customer = current_user.customers.where(:id => params[:customer_id]).first
      unless @customer
        respond_to do |format|
          format.html { redirect_to customers_path }
          format.json do
            render :json => { :result => false, :errors => { :messages => ["Customer not found"] } }
          end
        end
      end
    end

    def set_contact
      @contact = @customer.contacts.where(:id => params[:id]).first
      unless @contact
        respond_to do |format|
          format.html { redirect_to @customer }
          format.json do
            render :json => { :result => false, :errors => { :messages => ["Contact not found"] } }
          end
        end
      end
    end
end