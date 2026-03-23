Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    root to: "dashboard#index"
    resources :invitations, only: [:index, :create, :destroy]
    resources :users, only: [:index, :update]
    resources :projects, only: [:index, :destroy] do
      member do
        patch :unpublish
      end
    end
  end

  resources :invitations, only: [:show], param: :token do
    post :accept, on: :member
  end

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

  resources :projects, only: [:index, :show] do
    resource :like, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  resources :creators, only: [:show] do
    resource :follow, only: [:create, :destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "projects#index"
end
