Sovs::Application.routes.draw do
  resources :customers


  resources :sellers


  resources :providers


  devise_for :users
  
  resources :users do
    member do
      get :edit_profile
      put :update_profile
    end
  end
  
  root to: redirect('/users/sign_in')
end
