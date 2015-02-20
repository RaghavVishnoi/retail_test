class DocumentsController < DataFilesController

  private
    def data_file_params
      params.require(:document).permit(:name, :parent_id, :item_id, :description, :data_file, :sharable, :user_ids_string, :roles => [], :region_ids => [])
    end

    def initialize_data_file
      @data_file = current_user.owned_files.new :parent_id => params[:parent_id], :type => "Document"
    end
end