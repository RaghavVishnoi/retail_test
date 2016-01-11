module RepositoriesHelper
	def get_user
		User.find(session[:user_id])
	end

	def get_associated_role
		AssociatedRole.find_by(:object_id => get_user.id)
	end

	def get_role
		Role.find(get_associated_role.role_id)
	end

	def get_level
		case get_role.name
            when 'superadmin'
            	['1','2','3','4']
	        when 'approver'
	        	['1','2','3']
	        when 'cmo'
	        	['1','2']
	        when 'requester'
	        	'1'
	        	
        end
	end

	def get_repository
		Repository.where(:levels_id => get_level).pluck(:documents_id)
	end

	def get_document
		Document.where(:id => get_repository)
	end

	def get_tag(document_id)
		tag_name = []
		@repository = Repository.where(:documents_id => document_id)
		@repository.each do |repository|
			tag = Tag.where(:id => repository.tags_id).pluck(:tag_name)
			tag_name.push(tag)
		end
		tag_name.join(',')	
	end

	def add_document(document_param)
		
	   document_title = document_param[:document_title]
       level_id = Level.find_by(:level_name => document_param[:level]).id
       tag_id = Tag.where(:tag_name => document_param[:tag]).pluck(:id)
       insert_document_detail(document_param[:document_title],document_param[:file].original_filename,document_param[:file].size).save
       add_file(document_param[:file])
       create_association(level_id,tag_id)
      
    end

    def insert_document_detail(title,file_name,file_size)
    	@document = Document.new(:document_title => title,:uploaded_date => Time.now.to_date,:document_name => file_name,:file_size => file_size)
    end

    def add_file(file)
    	name =  file.original_filename
        directory = "public/uploads/repository/"+@document.id.to_s
        Dir.mkdir(directory) unless File.exists?(directory)
        path = File.join(directory, name)
	    File.open(path, "wb") { |f| f.write(file.read) }
    end

    def create_association(level_id,tag_ids)
    	tag_ids.each do |tag_id|
    	  Repository.new(:levels_id => level_id,:tags_id => tag_id,:documents_id => @document.id,:users_id => session[:user_id]).save
    	end
    end

    def get_uploaded_by(id)
      repository = Repository.find_by(:id => id)
      User.find_by(:id => repository.users_id)
	end

	def check_next(current)
		if current.to_i == 0
			next_page = 2
		else
			next_page = current.to_i+1
		end
		response = Document.all.paginate(:per_page => 11,:page => next_page)
		if response.length != 0
			'true'
		else
			'false'
		end
	end

	def get_repository_by_document(id)
		Repository.find_by(:documents_id => id)
	end
end
