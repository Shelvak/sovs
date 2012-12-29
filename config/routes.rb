Sovs::Application.routes.draw do

  resources :products do
    get :autocomplete_for_provider_name, on: :collection
  end

  resources :places, :customers, :sellers, :providers

  devise_for :users
  
  resources :users do
    member do
      get :edit_profile
      put :update_profile
    end
  end
  
  root to: redirect('/users/sign_in')
end
