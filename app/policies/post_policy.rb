# frozen_string_literal: true

# app/policies/post_policy.rb
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
      @record.user == @user
  end

  def destroy?
    user_is_admin? ||
      @record.user == @user
  end
end
