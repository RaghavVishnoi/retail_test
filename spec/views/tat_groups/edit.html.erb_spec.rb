require 'rails_helper'

RSpec.describe "tat_groups/edit", type: :view do
  before(:each) do
    @tat_group = assign(:tat_group, TatGroup.create!())
  end

  it "renders the edit tat_group form" do
    render

    assert_select "form[action=?][method=?]", tat_group_path(@tat_group), "post" do
    end
  end
end
