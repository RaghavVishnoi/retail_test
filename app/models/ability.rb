class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    # if user.superadmin?
    #   can :manage, :all
    #   can :manage, Organization
    # else
    #   can [:autocomplete], Item

    #   can [:autocomplete], User

    #   can [:edit, :update], User do |user_obj|
    #     user_obj == user
    #   end

    #   can [:read, :share], DataFile do |obj|
    #     obj.accessible_by?(user)
    #   end

    #   can :manage, DataFile do |obj|
    #     obj.user_id == user.id
    #   end

    #   can [:destroy, :create], CustomersUser do |obj|
    #     obj.accessible_by?(user)
    #   end
    # end
    
    user.permissions.each do |permission|     
      subject_class = (permission.subject_class == "all" ? :all : permission.subject_class.constantize)      
      can permission.action.to_sym, subject_class

    end

    can [:edit, :update], User do |obj|
      obj == user
    end

    can :manage, DataFile do |obj|
      obj.user_id == user.id
    end

    can [:read, :share], DataFile do |obj|
      obj.accessible_by?(user)
    end

    can [:destroy, :create], CustomersUser do |obj|
      obj.accessible_by?(user)
    end
  end

end
