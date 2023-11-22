# frozen_string_literal: true

# spec/requests/notifications_controller_spec.rb
require 'rails_helper'

RSpec.describe NotificationsController, type: :request do
  let(:user_instance) { create(:user, :admin) }

  before(:each) do
    create(:user_type, :writer)
    user_instance
    login_as User.first
  end

  describe 'PATCH #mark_as_read' do
    let!(:notification) { create(:notification, user: user_instance) }

    it 'marks the notification as read' do
      patch mark_as_read_notification_path(notification)

      expect(notification.reload.read).to eq(true)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE #destroy_all' do
    let!(:notifications) { create_list(:notification, 3, user: user_instance) }

    it 'destroys all notifications for the current user' do
      expect do
        delete destroy_all_notifications_path
      end.to change(Notification.where(user: user_instance), :count).from(3).to(0)

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('Notifications deleted!')
    end
  end
end