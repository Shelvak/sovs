require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @product = Fabricate(:product)
  end

  test 'create' do
    assert_difference ['Product.count', 'Version.count'] do
      @product = Product.create(
        Fabricate.attributes_for(:product, provider_id: @product.provider_id)
      )
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Product.count' do
        assert @product.update_attributes(description: 'Updated')
      end
    end

    assert_equal 'Updated', @product.reload.description
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Product.count', -1) { @product.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @product.code = ''
    @product.description = ''
    
    assert @product.invalid?
    assert_equal 2, @product.errors.size
    assert_equal [error_message_from_model(@product, :code, :blank)],
      @product.errors[:code]
    assert_equal [error_message_from_model(@product, :description, :blank)],
      @product.errors[:description]
  end
    
  test 'validates unique attributes' do
    new_product = Fabricate(:product)
    @product.code = new_product.code

    assert @product.invalid?
    assert_equal 1, @product.errors.size
    assert_equal [error_message_from_model(@product, :code, :taken)],
      @product.errors[:code]
  end

  test 'validates length of attributes' do
    @product.retail_unit = 'abcde' * 52
    @product.purchase_unit = 'abcde' * 52
    assert @product.invalid?
    assert_equal 2, @product.errors.count
    assert_equal [
      error_message_from_model(@product, :retail_unit, :too_long, count: 2)
    ], @product.errors[:retail_unit]
    assert_equal [
      error_message_from_model(@product, :purchase_unit, :too_long, count: 2)
    ], @product.errors[:purchase_unit]
  end

  test 'validates formatted attributes' do
    @product.unity_relation = '?xx'
    @product.packs = '?xx'
    @product.total_stock = '?xx'
    @product.min_stock = '?xx'
    @product.pack_content = '?xx'
    @product.cost = '?xx'
    @product.iva_cost = '?xx'
    @product.retail_price = '?xx'
    @product.unit_price = '?xx'
    @product.special_price = '?xx'
    @product.gain = '?xx'

    assert @product.invalid?
    assert_equal 11, @product.errors.count
    assert_equal [error_message_from_model(@product, :unity_relation, :not_a_number)],
      @product.errors[:unity_relation]
    assert_equal [error_message_from_model(@product, :packs, :not_a_number)],
      @product.errors[:packs]
    assert_equal [error_message_from_model(@product, :total_stock, :not_a_number)],
      @product.errors[:total_stock]
    assert_equal [error_message_from_model(@product, :min_stock, :not_a_number)],
      @product.errors[:min_stock]
    assert_equal [error_message_from_model(@product, :pack_content, :not_a_number)],
      @product.errors[:pack_content]
    assert_equal [error_message_from_model(@product, :cost, :not_a_number)],
      @product.errors[:cost]
    assert_equal [error_message_from_model(@product, :iva_cost, :not_a_number)],
      @product.errors[:iva_cost]
    assert_equal [error_message_from_model(@product, :retail_price, :not_a_number)],
      @product.errors[:retail_price]
    assert_equal [error_message_from_model(@product, :unit_price, :not_a_number)],
      @product.errors[:unit_price]
    assert_equal [error_message_from_model(@product, :special_price, :not_a_number)],
      @product.errors[:special_price]
    assert_equal [error_message_from_model(@product, :gain, :not_a_number)],
      @product.errors[:gain]

    @product.reload
    @product.packs = '0.01'
    assert @product.invalid?
    assert_equal 1, @product.errors.count
    assert_equal [error_message_from_model(@product, :packs, :not_an_integer)],
      @product.errors[:packs]
  end
end
