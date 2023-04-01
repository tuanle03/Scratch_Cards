Rails.application.routes.draw do
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users
  # Defines the root path route ("/")
  # root "articles#index"
end
