Sovs::Application.routes.draw do
  
  resources :sales, except: [:edit, :update, :destroy] do
    collection do
      get :autocomplete_for_customer_name
      get :autocomplete_for_product_name
      get :daily_report
      put :daily_report
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
  
  root to: redirect('/sales/new')
end
