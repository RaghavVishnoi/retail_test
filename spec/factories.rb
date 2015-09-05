FactoryGirl.define do  
  
 |f|
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    name 'name'
  end
end