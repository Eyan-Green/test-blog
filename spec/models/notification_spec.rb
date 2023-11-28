require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'Associations' do
    it 'belongs_to user' do
      t = Notification.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end
    it 'belongs_to actor' do
      t = Notification.reflect_on_association(:actor)
      expect(t.macro).to eq(:belongs_to)
    end
    it 'belongs_to actor' do
      t = Notification.reflect_on_association(:targetable)
      expect(t.macro).to eq(:belongs_to)
    end
  end

  describe 'Callbacks' do
    it 'creating a notification triggers after_create_commit' do
      notification = build(:notification)
      expect do
        notification.save
      end.to have_broadcasted_to(:notifications).from_channel(Turbo::StreamsChannel)
    end
  end
end
