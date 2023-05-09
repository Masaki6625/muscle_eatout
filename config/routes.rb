Rails.application.routes.draw do
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
    
  }

  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  
  devise_scope :user do
       post 'users/guest_sign_in' => 'public/sessions#guest_sign_in', as: 'guest_user'
  end


  namespace :admin do
    #root :to => "public/homes#top"
    resources :restaurants, only: [:index, :show]
    resources :users, only: [:index, :show, :destroy]
    resource :comments, only: [:create, :destory]
  end

  scope module: :public do
    root :to => 'homes#top'
    get 'about' => 'homes#about'
    get 'users/withdraw' => 'users#withdraw', as: 'withdraw'
    patch 'users/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
      resources :restaurants, only: [:new, :index, :create, :show, :edit, :update, :destroy] do
      resource :favorites, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    resources :users, only: [:index, :show, :edit, :update] do
    member do
    get :favorites
    end
  end
    resource :comments, only: [:create, :destory]
    resource :favorites, only: [:create, :destory]
    resource :relationships, only: [:create, :destory]
  end
 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
