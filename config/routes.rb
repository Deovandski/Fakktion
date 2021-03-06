# Router
Rails.application.routes.draw do

  mount_ember_app :frontend, to: "/"

  # Devise
  devise_for :users, controllers: {sessions: 'sessions'}

  # API Routes
  namespace :api do
    namespace :v1 do
      #resources :admin_messages || See Issue #32
      resources :posts
      resources :comments
      resources :comment_votes
      resources :inner_comments
      resources :inner_comment_votes
      resources :fact_types
      resources :topics
      resources :categories
      resources :genres
      resources :users
      resources :tokens, only: [:create]
    end
  end
end
