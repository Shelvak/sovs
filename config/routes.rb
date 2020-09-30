Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  get 'daily_boxes' => 'daily_box#index'
  put 'daily_boxes/print_daily_report' => 'daily_box#print_daily_report',
    as: 'print_daily_report'
  put 'print/low_stock' => 'print#low_stock', as: 'print_low_stock'

  get 'stats(.:format)' => 'stats#index', as: 'stats'
  get 'stats/sales_by_seller(.:format)' => 'stats#sales_by_seller',
    as: 'sales_by_seller_stats'
  get 'stats/sales_earn(.:format)' => 'stats#sales_earn',
    as: 'sales_earn_stats'
  get 'stats/payrolls(.:format)' => 'stats#payrolls',
    as: 'stats_payrolls'
  put 'stats/print_payrolls' => 'stats#print_payrolls',
    as: 'print_payrolls'
  get 'stats/sales_by_hours(.:format)' => 'stats#sales_by_hours',
    as: 'sales_by_hours_stats'
  get 'stats/products_day(.:format)' => 'stats#products_day_stats',
    as: 'products_day_stats'

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

  resources :places, :customers
  resources :sellers do
    collection do
      put :assign_current
    end
  end

  resources :transfer_products, except: [:edit, :update] do
    get :autocomplete_for_product_name, on: :collection
  end

  resources :providers do
    resources :products
    member do
      get :add_increase
    end

    collection do
      get :list_for_print
      post :print_list
    end
  end


  resources :users do
    member do
      get :edit_profile
      put :update_profile
    end
  end

  root to: redirect('/sales/new')
end
