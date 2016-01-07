module Api
  module V1
    class RepositoryController < ApplicationController 
     include RepositoriesHelper     
      skip_before_action :verify_authenticity_token
      PER_PAGE = 10
      def index
      	@documents = get_document.paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
      	render :json => {:result => true,:repository => @documents,:next => check_next(params[:page])}
      end

      def search
		  	repo = []
		  	title = params[:title]
		  	@documents = Document.where("upper(document_title) LIKE ?","#{title.upcase}%")
		  	@documents.each do |documents|
		  		document = {}
		  		repository = get_repository_by_document(documents.id)
		  		tag = get_tag(documents.id)
		  		uploader = get_uploaded_by(repository).name
		  		document.merge!(:id => documents.id)
		  		document.merge!(:title => documents.document_title)
		  		document.merge!(:name => documents.document_name)
		  		document.merge!(:uploaded_date => documents.uploaded_date.to_date.strftime("%b %d, %Y"))
		  		document.merge!(:tag_name => tag)
		  		document.merge!(:size => documents.file_size)
		  		document.merge!(:uploaded_by => uploader)
		  		repo.push(document)		  		 
		  	end
		  	render :json => {:result => true,:repository => repo,:next => check_next(params[:page])}
		  end

      private
	      def get_user
			User.find_by(:auth_token => params[:auth_token])
		  end
		  
		  def get_document
		  	repo = []
		  	repositories = get_repository.uniq
		  	repositories.each do |repository|
		  		document = {}
		  		documents = Document.find_by(:id => repository)
		  		tag = get_tag(documents.id)
		  		uploader = get_uploaded_by(get_repository_by_document(repository)).name
		  		document.merge!(:id => documents.id)
		  		document.merge!(:title => documents.document_title)
		  		document.merge!(:name => documents.document_name)
		  		document.merge!(:uploaded_date => documents.uploaded_date.to_date.strftime("%b %d, %Y"))
		  		document.merge!(:tag_name => tag)
		  		document.merge!(:size => documents.file_size)
		  		document.merge!(:uploaded_by => uploader)
		  		repo.push(document)		  		 
		    end
		  	repo
		  end



    end
  end
end