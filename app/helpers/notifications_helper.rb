# frozen_string_literal: true

# Notifications helper
module NotificationsHelper
  def notification_colour(current_user)
    current_user.unread_notifications.count.positive? ? 'fill-current text-red-500' : ''
  end

  def notification_read(notification)
    notification.read? ? 'text-gray-100' : 'bg-gray-100 p-2 rounded-md'
  end
end
