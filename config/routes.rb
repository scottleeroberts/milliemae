Rails.application.routes.draw do
  devise_for :designers
  root to: 'blog/posts#index'

  namespace :designers do
    resource 'account', only: [:edit, :update]
    resource 'change_password', only: [:update]
    resources :posts do
      put 'publish' => 'posts#publish', on: :member
      put 'unpublish' => 'posts#unpublish', on: :member
    end
  end

  scope module: 'blog' do
    get 'about' => 'pages#about', as: :about
    get 'contact' => 'pages#contact', as: :contact
    get 'posts' => 'posts#index', as: :posts
    get 'posts/:id' => 'posts#show', as: :post
  end

end
