require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)
    sign_in @user
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_select '#unexpected_error', false
    assert_template 'stats/index'
  end

  test 'should get sales by seller' do
    get :sales_by_seller
    assert_response :success
    assert assigns(:sales_by_seller_count).blank?
    assert_select '#unexpected_error', false
    assert_template 'stats/sales_by_seller'
  end

  test 'should get sales by seller with interval' do
    3.times { Fabricate(:sale) }
    
    get :sales_by_seller, interval: {
      from: 1.day.ago.to_datetime.to_s(:db),
      to: 1.day.from_now.to_datetime.to_s(:db)
    }
    assert_response :success
    assert_not_nil assigns(:sales_by_seller_count)
    assert_equal 3, assigns(:sales_by_seller_count).size
    assert_equal Sale.count, assigns(:sales_by_seller_count).sum(&:second)
    assert_select '#unexpected_error', false
    assert_template 'stats/sales_by_seller'
  end

  test 'should get sales earn' do
    get :sales_earn
    assert_response :success
    assert assigns(:sales_earn).blank?
    assert_select '#unexpected_error', false
    assert_template 'stats/sales_earn'
  end

  test 'should get sales earn with interval' do
    3.times { Fabricate(:sale) }
    
    get :sales_earn, interval: {
      from: 1.day.ago.to_datetime.to_s(:db),
      to: 1.day.from_now.to_datetime.to_s(:db)
    }
    assert_response :success
    assert_not_nil assigns(:sales_earn)
    assert_equal 1, assigns(:sales_earn).size
    assert_equal Sale.sum(:total_price), assigns(:sales_earn).sum(&:second)
    assert_select '#unexpected_error', false
    assert_template 'stats/sales_earn'
  end
end
