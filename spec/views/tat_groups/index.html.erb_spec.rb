require 'rails_helper'

RSpec.describe "tat_groups/index", type: :view do
  before(:each) do
    assign(:tat_groups, [
      TatGroup.create!(),
      TatGroup.create!()
    ])
  end

  it "renders a list of tat_groups" do
    render
  end
end
