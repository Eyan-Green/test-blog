class NotificationsController < ApplicationController
  before_action :set_notification, only: [:mark_as_read]

  def mark_as_read
    @notification.update(read: true)
    render turbo_stream: turbo_stream.replace("notification_#{@notification.id}",
                                              partial: 'shared/notification_li',
                                              locals: { notification: @notification })
  end

  def destroy_all
    @notifications = Notification.where(user: current_user)
    @notifications.destroy_all
    redirect_to root_path, notice: 'Notifications deleted!'
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
