Rails.application.routes.draw do
  get 'rooms/create'
  root 'homepages#show'
  devise_for :users
  resources :rooms, only: [:create, :new, :show]
  resources :rooms do
    delete :leave, on: :member
  end
  post "rooms/join", to: "rooms#join", as: :join_room
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
