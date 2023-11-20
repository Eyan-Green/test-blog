require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe 'Users helper' do
    it 'returns Lock when user is not locked' do
      user = create(:user, :writer)
      expect(lock_display(user)).to eq('Lock')
    end
    it 'returns Lock when user is not locked' do
      user = create(:user, :writer)
      user.lock_access!
      expect(lock_display(user)).to eq('Unlock')
    end
  end
end
