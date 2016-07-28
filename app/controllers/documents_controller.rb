class DocumentsController <  ApplicationController
 include RepositoriesHelper
  PER_PAGE = 50
  def index
    if params[:button] == 'search'
        @documents = Document.search(params[:type],params[:param],get_role).paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
        if @documents.length < 1
          redirect_to documents_path,:notice => "No document found"
        end
           
    else
  	    @documents = get_document.paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
        respond_to do |format|
            format.html 
            format.json {render :json => { :result => true, :documents => @documents}}
        end  
    end
    
  end

  def new
    @document = Document.new
  end

  def create
    @document = add_document document_param
    redirect_to documents_path,:notice => 'Document inserted successfully'
  end 

  def document_param
    params.require(:document).permit(:document_title, :level,{:tag => []}, :file_size, :file)
  end

end