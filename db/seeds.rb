# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# organization = Organization.new
# organization.save! :validate => false

# user = User.new :email => 'superadmin@fosem.com', :password => '12345', :name => "superadmin", :state => "delhi"
# user.save!

# superadmin_role = Role.create :name => 'superadmin'
# superadmin_role.permissions.create :action => "manage", :subject_class => "all"

# user.roles << superadmin_role

# ModuleGroup.create :name => :default
# ModuleGroup.create :name => :login
# ModuleGroup.create :name => :items
# ModuleGroup.create :name => :attendance
# ModuleGroup.create :name => :crm
# ModuleGroup.create :name => :survey
# ModuleGroup.create :name => :requester
# ModuleGroup.create :name => :vendor
 

# brands = %w{SAMSUNG HTC SONY NOKIA MICROMAX LAVA OPPO VIVO}

# brands.each do |brand_name|
#   field_name = "Branding available for #{brand_name} in this outlet"
#   Field.create :entity => "Request", :display_name => field_name, :field_type => 'checkbox', :value_type => 'string', :configuration => { :values => ["Glow sign board", "SIS", "RSP"], :type => "branding_details" }
# end

# Field.create :entity => "Request", :display_name => "Your requirement for this shop is for", :field_type => "checkbox", :value_type => 'string', :mandatory => true, :configuration => { :values => ["Clipon (4x3 feet) LANDSCAPE", "Clipon (3x4 feet) PORTRAIT", "Clipon (3x2 feet) LANDSCAPE", "Clipon (2x3 feet) PORTRAIT", "Standee with Lights", "Counter-top with Lights"], :name => "shop_requirements" }

# Role.create!([
# 	{name: 'approver'},
# 	{name: 'rsp'},
# 	{name: 'gionee manager'},
# 	{name: 'reader'},
# 	{name: 'cmo'},
# 	{name: 'vendor'},
# 	{name: 'requester'},
# 	{name: 'rrm'}
# ])

# Permission.create!([
# 	{role_id: '2',action: 'edit', subject_class: 'Request'},
# 	{role_id: '2',action: 'approve', subject_class: 'Request'},
# 	{role_id: '2',action: 'read', subject_class: 'Request'},
# 	{role_id: '2',action: 'update', subject_class: 'Request'},
# 	{role_id: '2',action: 'view', subject_class: 'Request'},
# 	{role_id: '2',action: 'approve', subject_class: 'VendorTask'},
# 	{role_id: '2',action: 'read', subject_class: 'VendorTask'},
# 	{role_id: '2',action: 'update', subject_class: 'VendorTask'},
# 	{role_id: '2',action: 'view', subject_class: 'VendorTask'},
# 	{role_id: '2',action: 'edit', subject_class: 'VendorTask'},
# 	{role_id: '2',action: 'manage', subject_class: 'User'},
# 	{role_id: '2',action: 'manage', subject_class: 'Retailer'},
# 	{role_id: '2',action: 'manage', subject_class: 'CMO'},
# 	{role_id: '2',action: 'manage', subject_class: 'Map'},
# 	{role_id: '2',action: 'manage', subject_class: 'VendorRequest'},
# 	{role_id: '2',action: 'manage', subject_class: 'Download'},
# 	{role_id: '2',action: 'manage', subject_class: 'Vendorlist'},
# 	{role_id: '2',action: 'manage', subject_class: 'Beatroute'},
# 	{role_id: '2',action: 'manage', subject_class: 'Notification'},
# 	{role_id: '2',action: 'manage', subject_class: 'Document'},
# 	{role_id: '5',action: 'read', subject_class: 'Request'},
# 	{role_id: '5',action: 'edit', subject_class: 'Request'},
# 	{role_id: '5',action: 'get', subject_class: 'Request'},
# 	{role_id: '5',action: 'view', subject_class: 'Request'},
# 	{role_id: '5',action: 'get', subject_class: 'VendorTask'},
# 	{role_id: '5',action: 'read', subject_class: 'VendorTask'},
# 	{role_id: '5',action: 'edit', subject_class: 'VendorTask'},
# 	{role_id: '5',action: 'manage', subject_class: 'Map'},
# 	{role_id: '6',action: 'cmo', subject_class: 'Request'},
# 	{role_id: '6',action: 'view', subject_class: 'Request'},
# 	{role_id: '6',action: 'update', subject_class: 'Request'},
# 	{role_id: '6',action: 'read', subject_class: 'Request'},
# 	{role_id: '6',action: 'edit', subject_class: 'Request'},
# 	{role_id: '6',action: 'cmo', subject_class: 'VendorTask'},
# 	{role_id: '6',action: 'view', subject_class: 'VendorTask'},
# 	{role_id: '6',action: 'update', subject_class: 'VendorTask'},
# 	{role_id: '6',action: 'read', subject_class: 'VendorTask'},
# 	{role_id: '6',action: 'edit', subject_class: 'VendorTask'},
# 	{role_id: '7',action: 'manage', subject_class: 'VendorAssignment'},
# 	{role_id: '9',action: 'edit', subject_class: 'Request'},
# 	{role_id: '9',action: 'read', subject_class: 'Request'},
# 	{role_id: '9',action: 'view', subject_class: 'Request'},
# 	{role_id: '9',action: 'rrm', subject_class: 'Request'},
# 	{role_id: '9',action: 'update', subject_class: 'Request'},
# 	{role_id: '9',action: 'update', subject_class: 'VendorTask'},
# 	{role_id: '9',action: 'manage', subject_class: 'User'},
# 	{role_id: '9',action: 'manage', subject_class: 'VendorRequest'},
# 	{role_id: '9',action: 'edit', subject_class: 'Map'}
# ])
# Level.create!([
# 	{level_name: 'Requester and above'},
# 	{level_name: 'CMO and above'},
# 	{level_name: 'Approver and above'},
# 	{level_name: 'RRM and above'}
# ])
# Permission.create!([
# 	{role_id: '1',action: 'manage', subject_class: 'all'}
# ])