require 'test_helper'

class TransferProductsControllerTest < ActionController::TestCase

  setup do
    @transfer_product = Fabricate(:transfer_product)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transfer_products)
    assert_select '#unexpected_error', false
    assert_template "transfer_products/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:transfer_product)
    assert_select '#unexpected_error', false
    assert_template "transfer_products/new"
  end

  test "should create transfer_product" do
    assert_difference('TransferProduct.count') do
      transfer_product = Fabricate.attributes_for(:transfer_product)
      transfer_product.delete('transfer_lines')
      transfer_product.merge!(
        transfer_lines_attributes: {
          1 => Fabricate.attributes_for(
            :transfer_line, transfer_product_id: nil
          )
        }
      )

      post :create, transfer_product: transfer_product
    end

    assert_redirected_to transfer_product_url(assigns(:transfer_product))
  end

  test "should show transfer_product" do
    get :show, id: @transfer_product
    assert_response :success
    assert_not_nil assigns(:transfer_product)
    assert_select '#unexpected_error', false
    assert_template "transfer_products/show"
  end

  test "should destroy transfer_product" do
    assert_difference('TransferProduct.count', -1) do
      delete :destroy, id: @transfer_product
    end

    assert_redirected_to transfer_products_path
  end
end
