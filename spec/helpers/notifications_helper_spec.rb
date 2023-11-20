# spec/helpers/notifications_helper_spec.rb
require 'rails_helper'

RSpec.describe NotificationsHelper, type: :helper do
  describe '#notification_colour' do
    let(:user_with_notifications) { create(:user, :writer) }
    let(:user_without_notifications) { create(:user, :writer) }

    it 'returns proper CSS class when user has unread notifications' do
      create_list(:notification, 3, user: user_with_notifications, read: false)
      allow(helper).to receive(:current_user).and_return(user_with_notifications)
      expect(helper.notification_colour(helper.current_user)).to eq('fill-current text-red-500')
    end

    it 'returns empty string when user has no unread notifications' do
      allow(helper).to receive(:current_user).and_return(user_without_notifications)
      expect(helper.notification_colour(helper.current_user)).to eq('')
    end
  end
end
