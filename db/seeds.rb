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
user.save!

superadmin_role = Role.create :name => 'superadmin'
superadmin_role.permissions.create :action => "manage", :subject_class => "all"

user.roles << superadmin_role

ModuleGroup.create :name => :default, :active => true
ModuleGroup.create :name => :login
ModuleGroup.create :name => :items
ModuleGroup.create :name => :attendance
ModuleGroup.create :name => :crm
ModuleGroup.create :name => :survey
ModuleGroup.create :name => :requester

brands = %w{SAMSUNG HTC SONY NOKIA MICROMAX XOLO OPPO VIVO}

brands.each do |brand_name|
  field_name = "Branding available for #{brand_name} in this outlet"
  Field.create :entity => "Request", :display_name => field_name, :field_type => 'dropdown', :value_type => 'string', :configuration => { :values => ["Glow sign board", "SIS", "RSP"]}
end