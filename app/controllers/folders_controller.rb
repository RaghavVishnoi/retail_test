class FoldersController < DataFilesController

  private
    def data_file_params
      params.require(:folder).permit(:name, :parent_id, :user_ids_string, :roles => [], :region_ids => [], :user_ids => [])
    end

    def initialize_data_file
      @data_file = current_user.owned_files.new :parent_id => params[:parent_id], :type => "Folder"
    end
end