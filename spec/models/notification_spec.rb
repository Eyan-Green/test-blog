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
  end
end
