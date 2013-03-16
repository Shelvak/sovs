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
    assert_equal Sale.count, 
      assigns(:sales_by_seller_count).map(&:second).sum(&:first)
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

  test 'should get sales by hours' do
    assert_equal 0, Sale.count

    seller = Fabricate(:seller)
    place = Fabricate(:place)
    time = Time.zone.now.end_of_day - 6.hours - 10.seconds

    assert_difference 'Sale.count', 4 do
      4.times do
        Fabricate(
          :sale, customer_id: nil, seller_id: seller.id, place_id: place.id,
          created_at: time
        )
      end
    end

    total_sold = Sale.all.sum(&:total_price).to_f

    get :sales_by_hours, search: { date: time.to_date }
    assert_response :success
    assert_select '#unexpected_error', false
    assert_template 'stats/sales_by_hours'
    assert_not_nil assigns(:day_stats)
    assert_equal 4, assigns(:day_stats)[time.hour][:hour_total_count]
    assert_equal total_sold,
      assigns(:day_stats)[time.hour][:hour_total_sold].to_f
    assert_not_nil assigns(:stats)
    assert_equal 4, assigns(:stats)[:total_count]
    assert_equal total_sold, assigns(:stats)[:total_sold].to_f
  end
end
