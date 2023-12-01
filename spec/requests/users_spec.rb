# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Google SSO', type: :request do
  let(:admin_instance) { create(:user, :admin) }
  let(:writer_instance) { create(:user, :writer) }

  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  describe 'GET /users/auth/google_oauth2/callback' do
    context 'when a user is signing in for the first time' do
      it 'creates a new user and signs them in' do
        create(:user_type, :writer)
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
          provider: 'google_oauth2',
          uid: '123456789',
          info: {
            email: 'test@example.com',
            name: 'Test User'
          }
        )

        get '/users/auth/google_oauth2/callback'

        user = User.find_by(email: 'test@example.com')
        expect(user).to be_present
        expect(user.provider).to eq('google_oauth2')
        expect(user.uid).to eq('123456789')

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('Successfully authenticated from Google account.')
      end
    end
  end

  describe 'GET /users' do
    context 'Authorised user' do
      it 'visits index page and has a h1 with All users text' do
        login_as admin_instance
        MeiliSearch::Rails::Utilities.reindex_all_models
        get '/users'
        expect(response.body).to include('All users')
        expect(response.body).to include('Use the search box to find a user.')
        #expect(response.body).to include(admin_instance.full_name)
        #expect(response.body).to include(admin_instance.email)
        #expect(response.body).to include(admin_instance.created_at.to_s)
        MeiliSearch::Rails::Utilities.clear_all_indexes
      end
    end

    context 'Unuthorised user' do
      before(:each) { login_as writer_instance }

      it 'is redirects to root_path' do
        get '/users'
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('You do not have permission to carry out this action.')
      end
    end
  end

  describe 'PATCH /user/:id' do
    before(:each) { login_as admin_instance }

    context 'User is not currently locked' do
      it 'locks user' do
        patch "/users/#{writer_instance.id}/toggle_lock"
        expect(response).to redirect_to(users_path)
        follow_redirect!
        expect(response.body).to include('User is now locked!')
      end

      it 'sends an email notification' do
        expect do
          patch "/users/#{writer_instance.id}/toggle_lock"
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'User is currently locked' do
      before(:each) do
        login_as admin_instance
        writer_instance.lock_access!
      end

      it 'Unlocks user' do
        patch "/users/#{writer_instance.id}/toggle_lock"
        expect(response).to redirect_to(users_path)
        follow_redirect!
        expect(response.body).to include('User is now unlocked!')
      end
    end

    context 'Unauthorised user' do
      before(:each) do
        login_as writer_instance
      end

      it 'redirects user to root_path' do
        patch "/users/#{writer_instance.id}/toggle_lock"
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('You do not have permission to carry out this action.')
      end
    end
  end
end
