class CreateNotificationJob < ApplicationJob
  queue_as :default

  def perform(user_id, commentable, comment)
    user = User.find(user_id)
    NotificationService.new(user, commentable, comment.reply_to_comment_or_post).create_new_notification
  end
end
