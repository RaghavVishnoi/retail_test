# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


organization = Organization.new
organization.save! :validate => false

user = User.new :email => 'superadmin@fosem.com', :password => '123456', :name => "superadmin"
user.roles << :superadmin
user.save!

ModuleGroup.create :name => :default, :active => true
ModuleGroup.create :name => :login
ModuleGroup.create :name => :items