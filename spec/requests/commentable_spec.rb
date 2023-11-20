# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:user) { create(:user, :admin) }
  let(:commentable) { create(:post, :post_type, user: create(:user, :writer)) }
  let(:commentable_by_current_user) { create(:post, :post_type) }
  let(:comment_commentable) { create(:comment) }

  before do
    login_as user
  end

  describe 'POST /post/:commentable_id/comments' do
    let(:valid_params) { { comment: { body: 'Test Comment' }, commentable_id: commentable.id } }
    let(:header_params) { { 'Accept' => 'text/vnd.turbo-stream.html' } }

    context 'with valid attributes' do
      it 'creates a new comment and renders the turbo_stream' do
        post "/posts/#{commentable.id}/comments", params: valid_params, headers: header_params

        expect(response).to be_successful
      end
      it 'sends an email notification' do
        expect do
          post "/posts/#{commentable.id}/comments", params: valid_params, headers: header_params
        end.to(have_enqueued_job.on_queue('default').with('CommentMailer', 'new_comment', 'deliver_now', { params: { user: commentable.user, post: commentable}, args: []}))
      end
      it 'create a notification in the DB' do
        post "/posts/#{commentable.id}/comments", params: valid_params, headers: header_params
        expect(Notification.all.count).to eq(1)
        expect(Notification.last.user).to eq(commentable.user)
        expect(Notification.last.actor).to eq(user)
        expect(Notification.last.read).to be(false)
        expect(Notification.last.type_of_notification).to eq('new_comment')
      end

      it 'does not create a notification when author comments on post' do
        post "/posts/#{commentable_by_current_user.id}/comments", params: valid_params, headers: header_params
        expect(Notification.all.count).to eq(0)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new comment and renders the turbo_stream with errors' do
        invalid_params = { comment: { body: '' }, commentable_id: commentable.id }
        post "/posts/#{commentable.id}/comments", params: invalid_params, headers: header_params

        expect(response).to be_successful
        expect(response.body).to include("</form></template></turbo-stream>")
      end
    end

    context 'when parent comment is provided' do
      it 'creates a new comment with a parent and renders the turbo_stream' do
        valid_params_with_parent = { comment: { body: 'Reply to Parent Comment' }, commentable_id: commentable.id, parent_id: commentable.id }
        post "/posts/#{commentable.id}/comments", params: valid_params_with_parent, headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to be_successful
      end
    end
  end

  describe 'POST /comments/:commentable_id/comments' do
    context 'with valid attributes' do
      it 'creates a new comment and renders the turbo_stream' do
        valid_params = { comment: { body: 'Test Comment' }, commentable_id: comment_commentable.id }
        post "/comments/#{comment_commentable.id}/comments", params: valid_params, headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to be_successful
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new comment and renders the turbo_stream with errors' do
        invalid_params = { comment: { body: '' }, commentable_id: comment_commentable.id }
        post "/comments/#{comment_commentable.id}/comments", params: invalid_params, headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to be_successful
        expect(response.body).to include("</form></template></turbo-stream>")
      end
    end

    context 'when parent comment is provided' do
      it 'creates a new comment with a parent and renders the turbo_stream' do
        valid_params_with_parent = { comment: { body: 'Reply to Parent Comment' }, commentable_id: comment_commentable.id, parent_id: comment_commentable.id }
        post "/comments/#{comment_commentable.id}/comments", params: valid_params_with_parent, headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to be_successful
      end
    end
  end
end
