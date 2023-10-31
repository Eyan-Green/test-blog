# frozen_string_literal: true

# Pundit policy for Post class
class PostPolicy < ApplicationPolicy
  def show?
    user_is_admin? ||
      user_is_writer?
  end

  def create?
    user_is_admin? ||
      user_is_writer?
  end

  def update?
    user_is_admin? ||
      @record.user_id == @user
  end

  def destroy?
    user_is_admin? ||
      @record.user_id == @user
  end
end
