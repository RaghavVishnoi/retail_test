require 'rails_helper'

describe WeeklyOff do
  it { should have_and_belong_to_many(:users) }
  it do
    should define_enum_for(:day).
      with(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])
  end
end