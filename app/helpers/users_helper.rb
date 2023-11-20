module UsersHelper
  def lock_display(user)
    user.access_locked? ? 'Unlock' : 'Lock'
  end
end
