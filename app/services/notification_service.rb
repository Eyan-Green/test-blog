class NotificationService
  attr_reader :current_user, :targetable, :notification_type

  def initialize(current_user, targetable, notification_type)
    @current_user = current_user
    @targetable = targetable
    @notification_type = notification_type
  end

  def create_new_notification
    return if current_user == targetable.user

    Notification.create(
      user: targetable.user,
      actor: current_user,
      type_of_notification: notification_type,
      targetable_id: targetable.id,
      targetable_type: targetable.class.name
    )
  end
end
