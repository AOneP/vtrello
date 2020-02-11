Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'boards#index'
  resources :boards do
    resources :lists, except: :new
  end

  resources :lists, only: [:show, :new, :create] do
    resources :todopoints, except: [:index]
  end

  resources :todopoints, only: [:show] do
    resources :comments, except: [:index, :new]
  end

  resources :locales, only: [:show], param: :locale

  resources :users, only: [:show, :edit, :update]
  resources :registrations, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]

  resources :confirmations, only: [:show, :create, :new], param: :token

end
