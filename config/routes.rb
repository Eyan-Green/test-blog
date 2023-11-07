Rails.application.routes.draw do
  root to: 'posts#index'
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  resources :posts do
    resources :comments, module: :posts
    resource :like, module: :posts
  end

  resources :comments do
    resources :comments, module: :comments
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
