require 'rails_helper'

describe Department do
  it { should have_and_belong_to_many(:users) }
  it { should validate_presence_of(:name) }
end