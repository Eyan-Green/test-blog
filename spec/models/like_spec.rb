require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:like_instance) { create(:like) }
  describe 'Associations' do
    it 'belongs to record' do
      t = Like.reflect_on_association(:record)
      expect(t.macro).to eq(:belongs_to)
    end
    it 'belongs to record' do
      t = Like.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end
    it 'has polymorphic relationship' do
      post = create(:post, :post_type)

      like_on_post = Like.create(record: post, user: create(:user))

      expect(like_on_post.record_type).to eq('Post')
      expect(like_on_post.record).to eq(post)
    end
  end
end
