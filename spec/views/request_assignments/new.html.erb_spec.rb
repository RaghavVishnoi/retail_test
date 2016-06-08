require 'rails_helper'

RSpec.describe "request_assignments/new", type: :view do
  before(:each) do
    assign(:request_assignment, RequestAssignment.new())
  end

  it "renders new request_assignment form" do
    render

    assert_select "form[action=?][method=?]", request_assignments_path, "post" do
    end
  end
end
