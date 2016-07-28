class Document < ActiveRecord::Base
  attr_accessor :level,:tag,:file
  has_one :repository,:foreign_key => "documents_id"
 
   def self.search(type,param,role)
   	 repository = get_type(type,param,role).pluck(:documents_id)
   	 Document.where(:id => repository)
   end

   def self.get_type(type,param,role)
   	  case type
   	    when 'By Tag Name'
   	       tag = Tag.where(:tag_name => param).pluck(:id) 
   	       get_level(role,type,tag)
   	    when 'By Title Name'
   	       document = Document.where(:document_title => param).pluck(:id) 
   	       get_level(role,type,document)
   	    when 'By Uploaded Date'
   	       document = Document.where(:uploaded_date => param.to_date.to_s).pluck(:id) 
   	       get_level(role,type,document)
   	    when 'By Uploaded By'
           repository = Repository.where(:users_id => get_user(param).id).pluck(:id)  
           get_level(role,type,repository)
       end 	 
   end

   def self.get_level(role,type,object)
   		 case role.name
   		   when 'superadmin'
   		   	get_repository(['1','2','3','4','5'],type,object)
   		   when 'approver'
   		   	get_repository(['1','2','3','4'],type,object)
         when 'rrm'
          get_repository(['1','2','3'],type,object)
   		   when 'cmo'
            get_repository(['1','2'],type,object)
   		   when 'requester'
            get_repository(['1'],type,object)
   		 end 
   		 
   end

   def self.get_repository(level,type,object)
       case type
   	    when 'By Tag Name'
   	      if object != nil
   	         Repository.where(:tags_id => object,:levels_id => level)
   	      end
   	    when 'By Title Name'
   	      if object != nil
   	      	 Repository.where(:documents_id => object,:levels_id => level)
   	      end
   	    when 'By Uploaded Date'
   	      if object != nil	
   	         Repository.where(:documents_id => object,:levels_id => level)
   	      end
   	    when 'By Uploaded By'
   	      if object != nil
             Repository.where(:id => object,:levels_id => level)
          end
      end
   end

   def self.get_user(email)
      User.find_by(:email => email)
   end

  

   
   
end