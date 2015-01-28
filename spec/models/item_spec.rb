require 'rails_helper'

describe Item do
  it { should belong_to(:city) }
  it { should belong_to(:category) }
  it { should belong_to(:subcategory) }
  it { should validate_presence_of(:name) }
end