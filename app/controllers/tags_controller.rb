class TagsController < ApplicationController

 def index
 end

 def new
 	@tag = Tag.new
 end

 def create
 	@tags = Tag.new tag_params
 	if @tags.save
 		render :json => {:result => 'success',:tag => @tags}
 	else
 		render :json => {:result => 'error'}
 	end
 end

 def tag_params
 	params.require(:tag).permit(:tag_name)
 end

end
