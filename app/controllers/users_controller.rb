# frozen_string_literal: true

# app/controller/users_controller.rb
class UsersController < ApplicationController
  before_action :set_user, only: %i[toggle_lock]

  def index
    authorize User
    users = User.pagy_search(params[:query])
    @pagy, @users = pagy_meilisearch(users, items: 25)
  rescue Pagy::OverflowError
    redirect_to users_path(page: 1)
  end

  def toggle_lock
    if @user.access_locked?
      @user.unlock_access!
      message = 'User is now unlocked!'
    else
      @user.lock_access!
      message = 'User is now locked!'
    end
    redirect_to users_path(page: params[:page]), notice: message
  end

  private

  def set_user
    authorize @user = User.find(params[:id])
  end
end
