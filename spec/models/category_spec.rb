require 'rails_helper'

describe Category do
  it { should have_many(:items) }
  it { should have_many(:subcategory_items) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end