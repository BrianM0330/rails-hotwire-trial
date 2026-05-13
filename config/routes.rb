Rails.application.routes.draw do
  root "landing#index"

  get "login", to: "sessions#new", as: :login
  delete "logout", to: "sessions#destroy", as: :logout
  get "signup", to: "users#new", as: :signup

  resources :photos, only: %i[index show] do
    resource :like, only: %i[create destroy]
  end

  resource :session, only: %i[new create destroy]
  resources :users, only: %i[new create]
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

end
