require 'rails_helper'

RSpec.describe "request_assignments/show", type: :view do
  before(:each) do
    @request_assignment = assign(:request_assignment, RequestAssignment.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
