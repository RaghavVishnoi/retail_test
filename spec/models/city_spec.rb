require 'rails_helper'

describe City do
  it { should have_many(:items) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end