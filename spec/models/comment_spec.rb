require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Associations' do
    it 'belongs to user' do
      t = Comment.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end
    it 'belongs to commentable' do
      t = Comment.reflect_on_association(:commentable)
      expect(t.macro).to eq(:belongs_to)
    end
  end
end
