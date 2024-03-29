Rails.application.routes.draw do
  get 'rooms/create'
  root 'homepages#show'
  devise_for :users
  resources :rooms, only: [:create, :new, :show]
  resources :rooms do
    delete :leave, on: :member
    member do
      put :ready
      put :unready
      post :join
      get 'game/:game_id', action: :game, as: :game
      get 'game/:game_id/cards', action: :cards, as: :cards_game
      post 'game/:game_id/submit', action: :submit_game, as: :submit_game
      get 'game/:game_id/result', action: :result, as: :result_game
    end
    collection do
      post :join_private
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
