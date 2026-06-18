Rails.application.routes.draw do
  resources :movies do
    collection do
      post :search_tmdb
    end
    member do
      get :same_director
    end
  end
  root 'movies#index'
end
