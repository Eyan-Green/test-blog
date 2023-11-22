class NotificationsController < ApplicationController
  before_action :set_notification, only: [:mark_as_read]

  def index
    @notifications = current_user.notifications.where(read: false)
    respond_to do |format|
      format.json { render json: @notifications }
    end
  end

  def mark_as_read
    @notification.update(read: true)
    render turbo_stream: [turbo_stream.replace("notification_#{@notification.id}",
                                               partial: 'shared/notification_li',
                                               locals: { notification: @notification }),
                          turbo_stream.update('notification_counter',
                                              partial: 'shared/notification_navbar',
                                              locals: { current_user: @notification.user })]
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
