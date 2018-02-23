Rails.application.routes.draw do
  root to: 'blog/posts#index'

  scope module: 'blog' do
    get 'about' => 'pages#about', as: :about
    get 'contact' => 'pages#contact', as: :contact
    resources :posts
  end
end
