# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  include Warden::Test::Helpers

  let(:instance) { create(:post, :post_type) }
  let(:user_instance) { create(:user, :admin) }

  before(:each) do
    create(:user_type, :writer)
    user_instance
    instance
    login_as User.first
  end

  describe 'Returns all posts' do
    it 'returns http success and renders all posts' do
      get '/posts'
      expect(response).to have_http_status(:success)
      expect(response.body).to include(instance.title)
      expect(response.body).to include(instance.content.to_plain_text)
      expect(response.body).to include('All posts')
    end
  end

  describe 'GET /show' do
    it 'returns http success and renders specific post' do
      get "/posts/#{Post.last.id}"
      expect(response).to have_http_status(:success)
      expect(response.body).to include(instance.title)
      expect(response.body).to include(instance.content.to_plain_text)
    end
  end

  describe 'POST create new post' do
    it 'creates a new post and then renders title and content' do
      get '/posts/new'
      expect(response).to have_http_status(:success)

      post '/posts', params: { post: { title: 'Title', content: 'Content', post_type_id: instance.post_type.id } }
      follow_redirect!
      expect(response.body).to include('Title')
      expect(response.body).to include('Content')
      expect(response.body).to include('Post was successfully created.')
    end
    it 'renders new form because the create was invalid' do
      get '/posts/new'
      expect(response).to have_http_status(:success)

      post '/posts', params: { post: { title: nil, content: 'Content' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('Post could not be created, please try again.')
      expect(response.body).to include('New post')
    end
  end

  describe 'GET edit and update a post' do
    it 'returns http success' do
      get "/posts/#{Post.last.id}/edit"
      expect(response).to have_http_status(:success)

      patch "/posts/#{Post.last.id}", params: { post: { title: 'Updated title', content: 'Updated content' } }
      follow_redirect!
      expect(response.body).to include('Updated title')
      expect(response.body).to include('Updated content')
      expect(response.body).to include('Post was successfully updated.')
    end
    it 'renders edit form because the update was invalid' do
      get "/posts/#{Post.last.id}/edit"
      expect(response).to have_http_status(:success)

      patch "/posts/#{Post.last.id}", params: { post: { title: nil, content: 'Updated content' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('Post could not be updated, please try again.')
      expect(response.body).to include('Edit post')
    end
  end

  describe 'DELETE /destroy' do
    it 'returns http success' do
      delete "/posts/#{Post.last.id}"
      follow_redirect!
      expect(response.body).to include('All posts')
      expect(response.body).to include('Post was successfully deleted.')
    end
  end
end
