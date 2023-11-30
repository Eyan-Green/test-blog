# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
require 'sidekiq/web'
Sidekiq::Web.app_url = '/'

Rails.application.routes.draw do
  root to: 'posts#index'

  authenticate :user, lambda { |u| u.user_type.name == 'Administrator' } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  resources :comments, except: [:index] do
    resources :comments, module: :comments, except: [:index]
  end
  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
    collection do
      delete :destroy_all
    end
  end
  resources :posts do
    resources :comments, module: :posts, except: [:index]
    resource :like, module: :posts, only: [:update]
  end
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }  
  resources :users, only: [:index] do
    member do
      patch :toggle_lock
    end
  end
end
