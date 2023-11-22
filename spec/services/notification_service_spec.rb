require 'rails_helper'

RSpec.describe NotificationService do
  let(:current_user) { create(:user, :admin) }
  let(:targetable) { create(:post, :post_type) }
  let(:notification_type) { 'new_comment_on_post' }

  describe '#create_new_notification' do
    context 'when current user is not the same as targetable user' do
      it 'creates a new notification' do
        notification_service = NotificationService.new(current_user, targetable, notification_type)

        expect do
          notification_service.create_new_notification
        end.to change(Notification, :count).by(1)
      end

      it 'creates a notification with correct attributes' do
        notification_service = NotificationService.new(current_user, targetable, notification_type)

        notification_service.create_new_notification
        notification = Notification.last

        expect(notification.user).to eq(targetable.user)
        expect(notification.actor).to eq(current_user)
        expect(notification.type_of_notification).to eq(notification_type)
        expect(notification.targetable_id).to eq(targetable.id)
        expect(notification.targetable_type).to eq(targetable.class.name)
      end
    end

    context 'when current user is the same as targetable user' do
      it 'does not create a new notification' do
        notification_service = NotificationService.new(targetable.user, targetable, notification_type)

        expect do
          notification_service.create_new_notification
        end.not_to change(Notification, :count)
      end
    end
  end
end
