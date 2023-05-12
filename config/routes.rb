Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  config = Rails.application.config.baukis2

  namespace :staff, path: "" do
    root "top#index"
    get "login" => "sessions#new", as: :login
    resource :session, only: [ :create, :destroy ]
    resource :account, expect: [ :new, :create, :destroy ] do
      patch :confirm
    end
    resource :password, only: [ :show, :edit, :update ]
    resources :customers
    resources :programs do
      resource :entries, only: [] do
        patch :update_all, on: :collection
      end
    end
    get "messages/count" => "ajax#message_count"
    post "messages/:id/tag" => "ajax#add_tag", as: :tag_message
    delete "messages/:id/tag" => "ajax#remove_tag"
    resources :messages, only: [ :index, :show, :destroy ] do
      get :inbound, :outbound, :deleted, on: :collection
      resource :reply, only: [ :new, :create ] do
        post :confirm
      end
    end
    resources :tags, only: [] do
      resources :messages, only: [ :index ] do
        get :inbound, :outbound, :deleted, on: :collection
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
    resource :account, expect: [ :new, :create, :destroy ] do
      patch :confirm
    end
    resources :programs, only: [ :index, :show ] do
      resource :entry, only: [ :create ] do
        patch :cancel
      end
    end
    resources :messages, only: [ :new, :create ] do
      post :confirm, on: :collection
    end
  end


end
