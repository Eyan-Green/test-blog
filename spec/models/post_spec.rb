# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  before(:each) { create(:user_type, :writer) }

  describe 'Associations' do
    it 'should belong to user' do
      t = Post.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end
    it 'should belong to post_type' do
      t = Post.reflect_on_association(:post_type)
      expect(t.macro).to eq(:belongs_to)
    end
    it 'should have many comments' do
      t = Post.reflect_on_association(:comments)
      expect(t.macro).to eq(:has_many)
    end
    it 'should have many notifications' do
      t = Post.reflect_on_association(:notifications)
      expect(t.macro).to eq(:has_many)
    end
    it 'should have many likes' do
      t = Post.reflect_on_association(:likes)
      expect(t.macro).to eq(:has_many)
    end
    it 'has polymorphic relationship notifications' do
      post = create(:post, :post_type)

      notification_on_post = Notification.create(targetable: post, user: create(:user))

      expect(notification_on_post.targetable_type).to eq('Post')
      expect(notification_on_post.targetable).to eq(post)
    end
    it 'has polymorphic relationship likes' do
      post = create(:post, :post_type)

      like_on_post = Like.create(record: post, user: create(:user))

      expect(like_on_post.record_type).to eq('Post')
      expect(like_on_post.record).to eq(post)
    end
    it 'has polymorphic relationship comments' do
      post = create(:post, :post_type)

      comment_on_post = Comment.create(commentable: post, user: create(:user), body: 'Text')

      expect(comment_on_post.commentable_type).to eq('Post')
      expect(comment_on_post.commentable).to eq(post)
    end
    it 'has a rich text attribute for content' do
      post = create(:post, :post_type)
      expect(post).to respond_to(:content)
      expect(post.content).to be_a(ActionText::RichText)
    end
  end

  describe 'Validations' do
    let(:user_instance) { create(:user, :admin) }

    it 'should validate the presence of title' do
      post = Post.new(content: 'Content', user_id: user_instance.id, title: nil)
      post.valid?
      expect(post.errors.full_messages).to include('Title can\'t be blank')
    end

    it 'should validate the presence of content' do
      post = Post.new(content: nil, user_id: user_instance.id, title: 'Title')
      post.valid?
      expect(post.errors.full_messages).to include('Content can\'t be blank')
    end

    it 'should validate the presence of user_id' do
      post = Post.new(content: 'Content', user_id: nil, title: 'Title')
      post.valid?
      expect(post.errors.full_messages).to include('User must exist')
    end
  end

  describe 'default_scope' do
    it 'orders posts by created_at in descending order' do
      post1 = create(:post, :post_type, created_at: 1.day.ago)
      post2 = create(:post, :post_type, created_at: Time.current)

      posts = Post.all

      expect(posts).to eq([post2, post1])
    end
  end

  describe 'Utility methods' do
    let(:instance) { create(:post, :post_type) }
    let(:like_instance) { create(:like) }

    it 'returns true when user has a like on post instance' do
      expect(like_instance.record.liked_by?(like_instance.user)).to be true
    end
    it 'returns false when user has no likes on post instance' do
      writer = create(:user, :writer)
      expect(like_instance.record.liked_by?(writer)).to be false
    end
    it 'returns the user like' do
      expect(like_instance.record.like(like_instance.user)).to eq(like_instance)
    end
    it 'creates a new like' do
      expect { instance.like(instance.user) }.to change(Like, :count).by(1)
    end
    it 'destroys all likes by user on a post instance' do
      like_instance
      expect { like_instance.record.unlike(like_instance.user) }.to change(Like, :count).by(-1)
    end
  end
end
