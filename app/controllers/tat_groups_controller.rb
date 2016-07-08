class TatGroupsController < ApplicationController
  before_action :set_tat_group, only: [:show, :edit, :update, :destroy]
  authorize_resource

  respond_to :html
  PER_PAGE = 50

  def index
    @tat_groups = TatGroup.all.paginate(:per_page => PER_PAGE,:page => params[:page])
    respond_with(@tat_groups)
  end

  def show
    respond_with(@tat_group)
  end

  def new
    @tat_group = TatGroup.new
    respond_with(@tat_group)
  end

  def edit
  end

  def create
    @tat_group = TatGroup.new(tat_group_params)
    @tat_group.save
    respond_with(@tat_group)
  end

  def update
    @tat_group.update(tat_group_params)
    respond_with(@tat_group)
  end

  def destroy
    @tat_group.destroy
    respond_with(@tat_group)
  end

  private
    def set_tat_group
      @tat_group = TatGroup.find(params[:id])
    end

    def tat_group_params
      params.require(:tat_group).permit(:name,:duration)
    end
end
