Sovs::Application.routes.draw do

  match 'daily_boxes' => 'daily_box#index', via: :get
  match 'daily_boxes/print_daily_report' => 'daily_box#print_daily_report', 
    as: 'print_daily_report', via: :put
  match 'print/low_stock' => 'print#low_stock', as: 'print_low_stock', via: :put

  match 'stats(.:format)' => 'stats#index', as: 'stats', via: :get
  match 'stats/sales_by_seller(.:format)' => 'stats#sales_by_seller',
    as: 'sales_by_seller_stats', via: :get
  match 'stats/sales_earn(.:format)' => 'stats#sales_earn',
    as: 'sales_earn_stats', via: :get
  match 'stats/payrolls(.:format)' => 'stats#payrolls',
    as: 'stats_payrolls', via: :get
  match 'stats/print_payrolls' => 'stats#print_payrolls',
    as: 'print_payrolls', via: :put
  match 'stats/sales_by_hours(.:format)' => 'stats#sales_by_hours',
    as: 'sales_by_hours_stats', via: :get
  match 'stats/products_day(.:format)' => 'stats#products_day_stats',
    as: 'products_day_stats', via: :get
    
  resources :sales, except: [:edit, :update, :destroy] do
    put :revoke, on: :member
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

  resources :transfer_products, except: [:edit, :update] do
    get :autocomplete_for_product_name, on: :collection
  end

  resources :providers do
    get :add_increase, on: :member
    resources :products, on: :member

    collection do
      get :list_for_print
      post :print_list
    end
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
