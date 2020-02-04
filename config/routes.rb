Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'boards#index'
  resources :boards do
    resources :lists, except: :new
  end
  resources :lists, only: [:show, :new, :create] do
    resources :todopoints, only: [:show, :new, :create, :edit, :update, :destroy]
  end

  resources :locales, only: [:show], param: :locale

end
