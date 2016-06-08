require 'rails_helper'

RSpec.describe "request_assignments/edit", type: :view do
  before(:each) do
    @request_assignment = assign(:request_assignment, RequestAssignment.create!())
  end

  it "renders the edit request_assignment form" do
    render

    assert_select "form[action=?][method=?]", request_assignment_path(@request_assignment), "post" do
    end
  end
end
