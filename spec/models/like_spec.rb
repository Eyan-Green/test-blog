require 'rails_helper'

RSpec.describe Like, type: :model do
  include ActionView::RecordIdentifier
  describe 'Associations' do
    it 'belongs to record' do
      t = Like.reflect_on_association(:record)
      expect(t.macro).to eq(:belongs_to)
    end
    it 'belongs to record' do
      t = Like.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end
  end
end
