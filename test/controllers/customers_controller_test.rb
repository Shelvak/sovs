require 'test_helper'

class CustomersControllerTest < ActionController::TestCase

  setup do
    @customer = Fabricate(:customer)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customers)
    assert_select '#unexpected_error', false
    assert_template "customers/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:customer)
    assert_select '#unexpected_error', false
    assert_template "customers/new"
  end

  test "should create customer" do
    assert_difference('Customer.count') do
      post :create, customer: Fabricate.attributes_for(:customer)
    end

    assert_redirected_to customer_url(assigns(:customer))
  end

  test "should show customer" do
    get :show, id: @customer
    assert_response :success
    assert_not_nil assigns(:customer)
    assert_select '#unexpected_error', false
    assert_template "customers/show"
  end

  test "should get edit" do
    get :edit, id: @customer
    assert_response :success
    assert_not_nil assigns(:customer)
    assert_select '#unexpected_error', false
    assert_template "customers/edit"
  end

  test "should update customer" do
    put :update, id: @customer, 
      customer: Fabricate.attributes_for(:customer)
    assert_redirected_to customer_url(assigns(:customer))
  end

  test "should destroy customer" do
    assert_difference('Customer.count', -1) do
      delete :destroy, id: @customer
    end

    assert_redirected_to customers_path
  end
end
