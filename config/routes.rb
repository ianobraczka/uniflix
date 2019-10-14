Rails.application.routes.draw do
  
  devise_for :users
  get 'category/index'
  get 'category/show'

  # get 'books/query_filtering', as: :query_filtering
  # post 'books/query_filtering', as: :query_filtering_search
  # get 'books/collaborative_filtering', as: :collaborative_filtering
  # get 'books/past_filtering', as: :past_filtering
  # get 'liked', controller: :books, as: :liked_book
  # post 'like/:book_id/:user_id', to: 'books#like', as: :like
  # post 'unlike/:book_id/:user_id', to: 'books#unlike', as: :unlike

  get 'movies/query_filtering', as: :query_filtering
  post 'movies/query_filtering', as: :query_filtering_search
  get 'movies/collaborative_filtering', as: :collaborative_filtering
  get 'movies/past_filtering', as: :past_filtering
  get 'liked', controller: :movies, as: :liked_book
  post 'like/:book_id/:user_id', to: 'movies#like', as: :like
  post 'unlike/:book_id/:user_id', to: 'movies#unlike', as: :unlike

  post '/rate/:movie_id/:user_id', to: 'reviews#review', as: :rate

  resources :movies
  resources :books
  resources :categories
  resources :reviews
  
  root 'movies#collaborative_filtering'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
