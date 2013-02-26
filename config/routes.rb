Sovs::Application.routes.draw do

  match 'daily_boxes' => 'daily_box#index', via: :get

  match 'stats(.:format)' => 'stats#index', as: 'stats', via: :get
  match 'stats/sales_by_seller(.:format)' => 'stats#sales_by_seller',
    as: 'sales_by_seller_stats', via: :get
  match 'stats/sales_earn(.:format)' => 'stats#sales_earn',
    as: 'sales_earn_stats', via: :get
  match 'stats/payrolls(.:format)' => 'stats#payrolls',
    as: 'stats_payrolls', via: :get
    
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
    get :put_to_stock, on: :member
  end

  resources :places, :customers, :sellers

  resources :providers do
    get :add_increase, on: :member
    resources :products, on: :member
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
