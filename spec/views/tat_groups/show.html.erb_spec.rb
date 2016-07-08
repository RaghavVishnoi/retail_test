require 'rails_helper'

RSpec.describe "tat_groups/show", type: :view do
  before(:each) do
    @tat_group = assign(:tat_group, TatGroup.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
