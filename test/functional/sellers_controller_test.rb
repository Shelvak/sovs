require 'test_helper'

class SellersControllerTest < ActionController::TestCase

  setup do
    @seller = Fabricate(:seller)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sellers)
    assert_select '#unexpected_error', false
    assert_template "sellers/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:seller)
    assert_select '#unexpected_error', false
    assert_template "sellers/new"
  end

  test "should create seller" do
    assert_difference('Seller.count') do
      post :create, seller: Fabricate.attributes_for(:seller)
    end

    assert_redirected_to seller_url(assigns(:seller))
  end

  test "should show seller" do
    get :show, id: @seller
    assert_response :success
    assert_not_nil assigns(:seller)
    assert_select '#unexpected_error', false
    assert_template "sellers/show"
  end

  test "should get edit" do
    get :edit, id: @seller
    assert_response :success
    assert_not_nil assigns(:seller)
    assert_select '#unexpected_error', false
    assert_template "sellers/edit"
  end

  test "should update seller" do
    put :update, id: @seller, 
      seller: Fabricate.attributes_for(:seller)
    assert_redirected_to seller_url(assigns(:seller))
  end

  test "should destroy seller" do
    assert_difference('Seller.count', -1) do
      delete :destroy, id: @seller
    end

    assert_redirected_to sellers_path
  end
end
