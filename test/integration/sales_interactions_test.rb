# encoding: utf-8

require 'test_helper'

class SalesInteractionsTest < ActionDispatch::IntegrationTest
  test 'should create a normal retail' do
    Fabricate(:seller, code: 3)
    Fabricate(:product, code: 100, retail_price: 10)

    login

    assert_page_has_no_errors!
    assert_equal new_sale_path, current_path
    
    fill_in 'sale_seller_code', with: 3
    select 'B', from: 'sale_sale_kind'
    fill_in 'sale_product_lines_attributes_0_auto_product_name', with: '100'
    find(
      '#sale_product_lines_attributes_0_auto_product_name'
    ).native.send_keys :tab

    assert page.has_css?('.product_line', count: 1)

    find(
      '#sale_product_lines_attributes_0_auto_product_name'
    ).native.send_keys :tab, :tab, :tab
    assert page.has_css?('.product_line', count: 2)

    # To find link, capybara do focus, and that add an aditional line
    click_link(I18n.t('view.sales.new_product_line'))
    assert page.has_css?('.product_line', count: 4)

    assert_equal 10.0, find_field('sale_total_price').value.to_f


    assert_difference 'Sale.count' do
      find('.btn-primary').click
    end
  
    # Probe that the blank product lines was deleted
    last_sale = Sale.order.last
    assert_equal 1, last_sale.product_lines.count

    assert_page_has_no_errors!
    assert_equal new_sale_path, current_path
  end
end
