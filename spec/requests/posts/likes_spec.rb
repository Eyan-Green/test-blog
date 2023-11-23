# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Posts::LikesController, type: :request do
  let(:user) { create(:user, :writer) }
  let(:post) { create(:post, :post_type) }

  before do
    login_as user
  end

  describe 'PATCH /posts/:post_id/likes' do
    it 'toggles the like status for a post' do
      initial_like_status = post.liked_by?(user)

      patch "/posts/#{post.id}/like", headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

      post.reload
      new_like_status = post.liked_by?(user)

      expect(new_like_status).not_to eq(initial_like_status)
      expect(response).to be_successful
    end

    it 'creates a notification' do
      patch "/posts/#{post.id}/like", headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

      expect(Notification.all.count).to eq(1)
      expect(Notification.last.user).to eq(post.user)
      expect(Notification.last.actor).to eq(user)
      expect(Notification.last.read).to be(false)
      expect(Notification.last.type_of_notification).to eq('new_like_on_post')
    end
  end
end
