require 'rails_helper'

RSpec.describe "request_assignments/index", type: :view do
  before(:each) do
    assign(:request_assignments, [
      RequestAssignment.create!(),
      RequestAssignment.create!()
    ])
  end

  it "renders a list of request_assignments" do
    render
  end
end
