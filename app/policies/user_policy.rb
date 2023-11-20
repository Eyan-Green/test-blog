# frozen_string_literal: true

# Pundit policy for Comment class
class UserPolicy < ApplicationPolicy
  def index?
    user_is_admin?
  end

  def toggle_lock?
    user_is_admin? && @record != @user
  end
end
