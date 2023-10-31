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
end
