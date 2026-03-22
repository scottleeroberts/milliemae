Rails.application.routes.draw do
  devise_for :users

  namespace :creator do
    resources :projects do
      member do
        patch :publish
        patch :unpublish
      end
      resources :project_images, only: [:create, :destroy] do
        resources :product_links, only: [:create, :update, :destroy], module: "project_images"
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
