class Ability
  include CanCan::Ability

  def initialize(user)
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    case user.role
    when "admin"
      can :manage, :all
    when "moderador"
      can :manage, Profile
    when "curador"
      can [:read, :create, :update, :preview, :log],
          Neuron,
          deleted: false
      cannot [:delete, :restore], Neuron
      can [:search, :approve], Content
    end
  end
end
