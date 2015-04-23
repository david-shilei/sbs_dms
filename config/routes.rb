Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  root to: "home#index"
  get "me", to: "home#me"
  get "intro", to: "home#intro"
  get "guide", to: "home#guide"
  get "news", to: "home#news"

  resources :groups do 
    member do
      post :add_member
    end
  end

  resources :users, except: [:new, :create] do
    member do
      get :admin_status
      get :approve
    end
  end

  resources :documents, except: [:index] do
    member do 
      get :download
    end
    collection do
      get :query
      post :search
    end

    resources :revisions, only: [:create, :destroy] do
      member do
        get :download
      end
    end
  end 

  resources :categories do
    member do
      get :subcategories
      post :create_subcategory
    end
  end

  resources :requests,  only: [:create, :index, :destroy] do
    member do
      get :approve
    end
  end

  resources :notifications,  only: [:show, :index, :destroy]
end