require 'test_helper'

class ProvidersControllerTest < ActionController::TestCase

  setup do
    @provider = Fabricate(:provider)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:providers)
    assert_select '#unexpected_error', false
    assert_template "providers/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:provider)
    assert_select '#unexpected_error', false
    assert_template "providers/new"
  end

  test "should create provider" do
    assert_difference('Provider.count') do
      post :create, provider: Fabricate.attributes_for(:provider)
    end

    assert_redirected_to provider_url(assigns(:provider))
  end

  test "should show provider" do
    get :show, id: @provider
    assert_response :success
    assert_not_nil assigns(:provider)
    assert_select '#unexpected_error', false
    assert_template "providers/show"
  end

  test "should get edit" do
    get :edit, id: @provider
    assert_response :success
    assert_not_nil assigns(:provider)
    assert_select '#unexpected_error', false
    assert_template "providers/edit"
  end

  test "should update provider" do
    put :update, id: @provider, 
      provider: Fabricate.attributes_for(:provider)
    assert_redirected_to provider_url(assigns(:provider))
  end

  test "should destroy provider" do
    assert_difference('Provider.count', -1) do
      delete :destroy, id: @provider
    end

    assert_redirected_to providers_path
  end

  test 'should get filtered index' do
    3.times do
      Fabricate(:provider, name: 'in_filtered_index')
    end

    get :index, q: 'filtered_index'
    assert_response :success
    assert_not_nil assigns(:providers)
    assert_equal 3, assigns(:providers).size
    assert assigns(:providers).all? { |u| u.to_s =~ /filtered_index/ }
    assert_not_equal assigns(:providers).size, Provider.count
    assert_select '#unexpected_error', false
    assert_template 'providers/index'
  end

  test 'should add increase' do
    3.times do
      Fabricate(
        :product, provider_id: @provider.id,
        cost: 10,
        iva_cost: 10,
        gain: 10,
        retail_price: 11,
        unit_price: 11,
        special_price: 11
      )
    end

    get :add_increase, id: @provider.id, add: 10
    assert_redirected_to provider_url(@provider)
    @provider.reload
    @provider.products.each do |product|
      assert_equal 11, product.cost
      assert_equal 11, product.iva_cost
      assert_equal 12.1, product.retail_price
      assert_equal 12.1, product.unit_price
      assert_equal 12.1, product.special_price
    end
  end
end
