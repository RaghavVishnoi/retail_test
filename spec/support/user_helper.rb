module UserHelper
  def initialize_current_user
    @permission = mock_model(Permission, :action => :manage, :subject_class => "all")
    @current_user = mock_model(User, :permissions => [@permission])
    controller.stub(:current_user).and_return(@current_user)
  end
end