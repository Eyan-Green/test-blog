# frozen_string_literal: true

# app/helpers/users_helper.rb
module UsersHelper
  def lock_display(user)
    user.access_locked? ? 'Unlock' : 'Lock'
  end
end
