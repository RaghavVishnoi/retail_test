require 'rails_helper'

RSpec.describe "tat_groups/new", type: :view do
  before(:each) do
    assign(:tat_group, TatGroup.new())
  end

  it "renders new tat_group form" do
    render

    assert_select "form[action=?][method=?]", tat_groups_path, "post" do
    end
  end
end
