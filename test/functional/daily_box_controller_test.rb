require 'test_helper'

class DailyBoxControllerTest < ActionController::TestCase
  setup do
    user = Fabricate(:user)
    sign_in user
  end

  test "should get empty index" do
    get :index
    assert_response :success
    assert assigns(:boxes).blank?
    assert_select '#unexpected_error', false
    assert_template "shared/_empty_index"
  end

  test 'should get index' do
    assert_difference 'Sale.count' do
      Fabricate(:sale)
    end

    get :index
    assert_response :success
    assert_not_nil assigns(:boxes)
    assert_select '#unexpected_error', false
    assert_template "daily_box/index"
  end
end
