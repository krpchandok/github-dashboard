Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "/webhooks/github", to: "webhooks#github"

  root "repositories#index"
  resources :repositories, only: [:index, :show, :update]
end