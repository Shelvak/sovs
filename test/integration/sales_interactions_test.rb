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
    sleep 0.5
    find(
      '#sale_product_lines_attributes_0_auto_product_name'
    ).native.send_keys :tab

    assert_equal 10.0, find_field('sale_total_price').value.to_f
    assert page.has_css?('.product_line', count: 1)

    find('.btn[data-dynamic-form-event="addNestedItem"]').click
    assert page.has_css?('.product_line', count: 2)

    find('body').native.send_keys :left_control, :left_alt, 'a'
    assert page.has_css?('.product_line', count: 3)

    assert_difference 'Sale.count' do
      find('.btn-primary').click
    end


    assert_page_has_no_errors!
    assert_equal new_sale_path, current_path
  end
end
