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
  describe 'Callbacks' do
    it 'creating a like triggers after_create_commit' do
      like = Like.new(user: create(:user, :writer), record: create(:post, :post_type))
      expect do
        like.save
      end.to have_broadcasted_to("#{like.record.to_gid_param}:likes").from_channel(Turbo::StreamsChannel)
    end

    it 'destroying a like triggers after_destroy_commit' do
      expect do
        like_instance.destroy
      end.to have_broadcasted_to("#{like_instance.record.to_gid_param}:likes").from_channel(Turbo::StreamsChannel)
    end
  end
end
