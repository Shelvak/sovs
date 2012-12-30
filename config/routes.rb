Sovs::Application.routes.draw do

  resources :sales do
    collection do
      get :autocomplete_for_customer_name
      get :autocomplete_for_product_name
    end
  end

  resources :products do
    get :autocomplete_for_provider_name, on: :collection
  end

  resources :places, :customers, :sellers

  resources :providers do
    get :add_increase, on: :member
  end

  devise_for :users
  
  resources :users do
    member do
      get :edit_profile
      put :update_profile
    end
  end
  
  root to: redirect('/users/sign_in')
end
