require 'rails_helper'

describe JobTitle do
  it { should have_and_belong_to_many(:users) }
  it { should validate_presence_of(:title) }
end