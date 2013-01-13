require 'test_helper'

class ProductLineTest < ActiveSupport::TestCase
  def setup
    @product_line = Fabricate(:product_line)
  end

  test 'create' do
    assert_difference ['ProductLine.count', 'Version.count'] do
      @product_line = ProductLine.create(Fabricate.attributes_for(
        :product_line, 
        sale_id: @product_line.sale_id, 
        product_id: @product_line.product_id
      ))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'ProductLine.count' do
        assert @product_line.update_attributes(price: 100)
      end
    end

    assert_equal 100, @product_line.reload.price
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('ProductLine.count', -1) { @product_line.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @product_line.product_id = ''
    @product_line.quantity = ''
    @product_line.price = ''
    @product_line.unit_price = ''
    
    assert @product_line.invalid?
    assert_equal 4, @product_line.errors.size
    assert_equal [error_message_from_model(@product_line, :product_id, :blank)],
      @product_line.errors[:product_id]
    assert_equal [error_message_from_model(@product_line, :quantity, :blank)],
      @product_line.errors[:quantity]
    assert_equal [error_message_from_model(@product_line, :price, :blank)],
      @product_line.errors[:price]
    assert_equal [error_message_from_model(@product_line, :unit_price, :blank)],
      @product_line.errors[:unit_price]
  end

  test 'validate formated attributes' do
    @product_line.quantity = 'rock'
    @product_line.price = 'rock'
    @product_line.unit_price = 'rock'

    assert @product_line.invalid?
    assert_equal 3, @product_line.errors.size
    assert_equal [error_message_from_model(@product_line, :quantity, :not_a_number)],
      @product_line.errors[:quantity]
    assert_equal [error_message_from_model(@product_line, :price, :not_a_number)],
      @product_line.errors[:price]
    assert_equal [error_message_from_model(@product_line, :unit_price, :not_a_number)],
      @product_line.errors[:unit_price]

    @product_line.reload
    @product_line.quantity = -2.5
    @product_line.price = -1.3
    @product_line.unit_price = -1.3

    assert @product_line.invalid?
    assert_equal 3, @product_line.errors.size
    assert_equal [error_message_from_model(@product_line, :quantity, :greater_than, count: 0)],
      @product_line.errors[:quantity]
    assert_equal [error_message_from_model(@product_line, :price, :greater_than, count: 0)],
      @product_line.errors[:price]
    assert_equal [error_message_from_model(@product_line, :unit_price, :greater_than, count: 0)],
      @product_line.errors[:unit_price]
  end
end
