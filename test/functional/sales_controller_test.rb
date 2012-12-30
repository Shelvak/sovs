require 'test_helper'

class SalesControllerTest < ActionController::TestCase

  setup do
    @sale = Fabricate(:sale)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales)
    assert_select '#unexpected_error', false
    assert_template "sales/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:sale)
    assert_select '#unexpected_error', false
    assert_template "sales/new"
  end

  test "should create sale" do
    assert_difference('Sale.count') do
      post :create, sale: Fabricate.attributes_for(:sale)
    end

    assert_redirected_to sale_url(assigns(:sale))
  end

  test "should show sale" do
    get :show, id: @sale
    assert_response :success
    assert_not_nil assigns(:sale)
    assert_select '#unexpected_error', false
    assert_template "sales/show"
  end

  test "should get edit" do
    get :edit, id: @sale
    assert_response :success
    assert_not_nil assigns(:sale)
    assert_select '#unexpected_error', false
    assert_template "sales/edit"
  end

  test "should update sale" do
    put :update, id: @sale, 
      sale: Fabricate.attributes_for(:sale)
    assert_redirected_to sale_url(assigns(:sale))
  end

  test "should destroy sale" do
    assert_difference('Sale.count', -1) do
      delete :destroy, id: @sale
    end

    assert_redirected_to sales_path
  end
end
