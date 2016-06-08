class User < ActiveRecord::Base
  attr_accessor :skip_password_validation, :password_required,:supervisor_id
  attr_writer :shift_start_time, :shift_end_time
  # attr_accessor :phone

  after_create :create_user_data
  after_update :user_parents
  before_update :is_auditor?

  USER_TYPE = ['All','CMO','APPROVER','REQUESTER']

  has_secure_password :validations => false

  has_many :associated_roles, :as => :object, :dependent => :destroy
  has_many :roles, :through => :associated_roles
  has_many :permissions, :through => :roles
  has_and_belongs_to_many :departments
  has_and_belongs_to_many :regions
  has_and_belongs_to_many :business_units
  has_and_belongs_to_many :job_titles
  has_and_belongs_to_many :weekly_offs
  has_many :data_files_users
  has_many :data_files, :through => :data_files_users
  has_many :owned_files, :class_name => "DataFile", :foreign_key => :user_id
  has_many :attendances, :dependent => :destroy
  has_many :users_reportings, :foreign_key => :report_to_user_id, :dependent => :destroy
  has_many :users_to_report, :foreign_key => :reporting_user_id, :class_name => "UsersReporting", :dependent => :destroy
  has_many :reporting_users, :through => :users_reportings
  has_many :report_to_users, :through => :users_to_report
  has_many :reporting_users_attendances, :through => :users_reportings, :source => :attendances
  has_many :customers_users, :dependent => :destroy
  has_many :customers, :through => :customers_users
  has_many :cmos
  has_many :users
  has_many :user_parents
  has_many :shop_assignments
  
  has_many :user_data
  has_many :user_states, :as => :user, :dependent => :destroy
  has_many :states, :through => :user_states
 
  validates_confirmation_of :password, :if => ->{ password.present? }
  validates :email, :presence => true, :uniqueness => true
  validates :name, :presence => true
  validate  :state
  validates :reset_password_token, :uniqueness => true, :allow_nil => true
  validates :password, :presence => true, :unless => :password_not_required?
  validate  :supervisor_id,:if => :is_auditor?
  # validates :phone,   :presence => {:message => 'Wrong Format!'},
  #                    :numericality => true,
  #                    :length => { :minimum => 10, :maximum => 15 }
  validate :phone

  #validates :state_ids, presence: true
  #validates :role_ids, presence: true
  before_validation :set_shift_time_in_seconds
  before_save :ensure_auth_token
  before_create :set_reset_password_token
  after_create :send_invite_mail

  scope :with_password, -> { where('password_digest is not null') }
  scope :with_email, ->(email) { where(:email => email,:status => 'Active') }

  def self.with_name(name)
    if name.present?
      where("name like ?", "%#{name}%")
    else
      []
    end
  end

  


  def personalized_message
    "Hi #{name}"
  end

  def set_reset_password_token
    self.reset_password_sent_at = Time.current
    self.reset_password_token = generate_token(:reset_password_token)
  end

  def attendance
    attendances.between_time(Time.current.beginning_of_day, Time.current.end_of_day).first || attendances.new
  end

  def shift_start_time
    TimeHandler.day_time(timezone, shift_start_time_in_seconds)
  end

  def shift_end_time
    TimeHandler.day_time(timezone, shift_end_time_in_seconds)
  end

  private
    
    def password_not_required?
      !password_required && (skip_password_validation || password_digest?)
    end

    def is_auditor?
        if Role.where(id: role_ids).pluck(:name).include?('auditor') && supervisor_id != nil
           errors.add(:error!, 'Please select a supervisor!') if supervisor_id.to_i == 0
        end
    end

    def ensure_auth_token
      if auth_token.blank?
        self.auth_token = generate_token(:auth_token)
      end
    end

    def generate_token(col)
      loop do
        token = SecureRandom.hex(16)
        break token unless User.where(col => token).first
      end
    end


    def self.get_role(id)
      @user = User.find_by(:id => id)
      @associated_roles = AssociatedRole.find_by(:object_id => id)
      @role = @associated_roles.role.name 
    end

    def self.list_users(params,current_user)
        search_role = params[:search].split(',') if params[:search] != nil
        search_email = params[:email]
        user_ids = UserState.where(state_id: State.states(current_user)).pluck(:user_id) - [current_user.id]
        if search_role != nil
          search_roles(search_role).where(id: user_ids)
        elsif search_email != nil
          @permit_roles = permit_role(user_role(current_user.id)) 
          user = permit_users(@permit_roles)
          user.where("email = ?", search_email.strip).where(id: user_ids)
        else
          @permit_roles = permit_role(user_role(current_user))           
          permit_users(@permit_roles).where(id: user_ids)  
        end                      
    end

    def self.search_roles(search_role)
        case search_role
          when nil,''
            @permit_roles = permit_role(user_role(id)) 
          else
            @permit_roles = search_role          
          end
           permit_users(@permit_roles)      
    end

    def self.permit_users(permit_roles)
         roles = Role.where(name: permit_roles)
          object_id = []
          roles.each do |role|
            object_id.push(AssociatedRole.where(role_id: role.id).pluck(:object_id))
          end
          User.where(id: object_id.flatten)       
    end

    def self.find_users(role)
        @role = Role.where(:name => role)
        @associated_roles = AssociatedRole.where(:role_id => @role)
        @object_id = []
        @associated_roles.each do |associated_roles|
          @object_id = @object_id.push(associated_roles.object_id)
        end
        @users = User.where(:id => @object_id)
    end

    def self.users_data(role)
      users = find_users(role)
      users.map{|user| ["#{user.name}-#{user.states.pluck(:name).join(',')}",user.id]}
    end

    def self.users_data_with_token(role)
      users = find_users(role)
      users.map{|user| ["#{user.name}-#{user.states.pluck(:name).join(',')}",user.auth_token]}
    end



    def self.search(id,role)
      @user = self.where(email: id)
          if @user != nil
            roles = @user[0].roles[0]
            if permit_role(role).include? roles.name
              @user
            end
          end        
    end

    def send_invite_mail
       UserMailer.delay.invite_mail(email, reset_password_token)
    end

    def set_shift_time_in_seconds
      if @shift_start_time
        self.shift_start_time_in_seconds = TimeHandler.seconds(timezone, @shift_start_time)
      end
      if @shift_end_time
        self.shift_end_time_in_seconds = TimeHandler.seconds(timezone, @shift_end_time)
      end
    end

    def self.user_roles(id)
      user = User.find_by(:id => id)           
      associated_roles = AssociatedRole.where(:object_id => id) 
      role = []
        associated_roles.each do |associated_role|
          role.push(associated_role.role.name)   
        end
         role
    end

    def self.user_role(id)
      user = User.find_by(:id => id)
      associated_roles = AssociatedRole.where(:object_id => id).pluck(:role_id)
      role = Role.where(id: associated_roles).order('name desc').first
    end


    def self.delete_at_multi(role,set)
      @role = role
      roles = []
      set.each do |i|
        roles.push(@role[i])
      end
     @role - roles
    end

    def self.permit_role(role)
      roles = Role.all.pluck(:name) 
      case role.name
      when 'superadmin'
        delete_at_multi(roles,[0,2,3,4])
      when 'approver'
        delete_at_multi(roles,[0,1,2,3,4,9,10,11])
      when 'rrm'
        delete_at_multi(roles,[0,1,2,3,4,8,9,10,11])
      when 'cmo'
        delete_at_multi(roles,[0,1,2,3,4,5,8,9,10,11])
      when 'vmqa'
        delete_at_multi(roles,[0,1,2,3,4,5,6,7,8,9,12])
      when 'supervisor'
        delete_at_multi(roles,[0,1,2,3,4,5,6,7,8,9,10,12])
      when 'auditor'
        delete_at_multi(roles,[0,1,2,3,4,5,6,7,8,9,10,11])
      end             
    end

    def self.acceptable_role(role)
      @role = permit_role(role) 
      @role.delete(VENDOR) if @role.include?(VENDOR)
      if @role != nil
        Role.where(name: @role).pluck(:name,:id) 
      else
        ""
      end
    end

    private
      def create_user_data
        self.role_ids.compact.each do |role_id|
          UserData.create!(name: self.name,location: State.where(id: self.state_ids).pluck(:name).join(','),designation: Role.find(role_id).name,email: self.email ,status: self.status,phone: self.phone,user_id: self.id)
        end
        if Role.where(id: self.role_ids).pluck(:name).include?('auditor')
          UserParent.create(parent_id: self.supervisor_id,user_id: self.id,role: 'auditor')
        end
      end

      def user_parents
        if User.find(id).roles.pluck(:name).include?('auditor')
           parent =  UserParent.find_by(user_id: self.id,role: 'auditor')
            if parent != nil
              parent.update(parent_id: self.supervisor_id)
            end
        end
      end


  end  