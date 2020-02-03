Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'boards#index'
  resources :boards
  resources :lists
  resources :locales, only: [:show], param: :locale

end
