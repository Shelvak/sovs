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
      sale = Fabricate.attributes_for(:sale)
      sale.delete(:product_lines)
      sale.merge!(product_lines_attributes: {
        1 => Fabricate.attributes_for(:product_line, sale_id: nil)
      })
      post :create, sale: sale
    end

    assert_redirected_to new_sale_url
  end

  test "should show sale" do
    get :show, id: @sale
    assert_response :success
    assert_not_nil assigns(:sale)
    assert_select '#unexpected_error', false
    assert_template "sales/show"
  end

  test "should print daily report" do
    get :daily_report
    assert_response :success
    assert_select '#unexpected_error', false
    assert_template "sales/daily_report"

    put :daily_report, to_print: { date: Date.today }
    assert_redirected_to sales_url
  end

  test "should revoke" do
    put :revoke, id: @sale
    assert_redirected_to sales_url
  end
end
