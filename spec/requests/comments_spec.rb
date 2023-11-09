# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:instance) { create(:comment) }
  let(:user_instance) { create(:user, :admin) }

  before(:each) do
    create(:user_type, :writer)
    user_instance
    login_as User.first
  end

  describe 'GET #show' do
    it 'has 200 HTTP status' do
      get comment_path(instance)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #edit' do
    it 'has 200 HTTP status' do
      get edit_comment_path(instance)
      expect(response).to have_http_status(200)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the comment and redirects to the comment' do
        updated_body = 'Updated comment body'
        patch comment_path(instance), params: { comment: { body: updated_body } }
        instance.reload

        expect(instance.body.to_plain_text).to eq(updated_body)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the comment and re-renders the edit template' do
        patch comment_path(instance), params: { comment: { body: '' } }
        instance.reload

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the comment and redirects to the commentable resource' do
      commentable = instance.commentable
      delete comment_path(instance)
      expect { instance.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).to redirect_to(commentable)
    end
  end
end
