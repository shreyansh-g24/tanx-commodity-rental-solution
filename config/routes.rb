Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :lenders do
    resources :commodities, only: %i[index new create]
    resources :listings, only: %i[new create]
  end

  namespace :renters do
    resources :bids, only: %i[create]
  end

  resources :users, only: :new do
    collection do
      post "login", to: "users#login"
      get "logout", to: "users#logout"
    end
  end
  post "/user/signup", to: "users#create"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
