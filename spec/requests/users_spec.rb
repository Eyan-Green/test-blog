require 'rails_helper'

RSpec.describe 'Google SSO', type: :request do
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
end
