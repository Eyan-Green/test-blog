# frozen_string_literal: true

# Pundit application policy
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    def user_is_admin?
      @user.user_type.name == 'Administrator'
    end

    def user_is_writer?
      @user.user_type.name == 'Writer'
    end

    private

    attr_reader :user, :scope
  end

  def user_is_admin?
    @user.user_type.name == 'Administrator'
  end

  def user_is_writer?
    @user.user_type.name == 'Writer'
  end
end
