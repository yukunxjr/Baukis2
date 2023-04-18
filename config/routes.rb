Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  config = Rails.application.config.baukis2


  namespace :staff, path: "" do
    root "top#index"
    get "login" => "sessions#new", as: :login
    resource :session, only: [ :create, :destroy ]
    resource :account, expect: [ :new, :create, :destroy ]
    resource :password, only: [ :show, :edit, :update ]
    resources :customers
    resources :programs do
      resource :entries, only: [] do
        patch :update_all, on: :collection
      end
    end
  end

  namespace :admin do
    root "top#index"
    get "login" => "sessions#new", as: :login
    resource :session, only: [ :create, :destroy ]
    resources :staff_members do
      resources :staff_events, only: [:index]
    end
    resources :staff_events, only: [:index]
  end

  namespace :customer do
    root "top#index"
    get "login" => "sessions#new", as: :login
    resource :session, only: [ :create, :destroy ]
    resources :programs, only: [ :index, :show ] do
      resource :entry, only: [ :create ] do
        patch :cancel
      end
    end
  end


end
