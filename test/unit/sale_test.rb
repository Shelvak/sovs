require 'test_helper'

class SaleTest < ActiveSupport::TestCase
  def setup
    @sale = Fabricate(:sale)
  end

  test 'create' do
    assert_difference ['Sale.count', 'Version.count'] do
      @sale = Sale.create(Fabricate.attributes_for(
        :sale, customer_id: @sale.customer_id, seller_id: @sale.seller_id)
      )
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Sale.count' do
        assert @sale.update_attributes(sale_kind: 'U')
      end
    end

    assert_equal 'U', @sale.reload.sale_kind
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Sale.count', -1) { @sale.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @sale.seller_id = ''
    @sale.total_price = ''
    
    assert @sale.invalid?
    assert_equal 2, @sale.errors.size
    assert_equal [error_message_from_model(@sale, :seller_id, :blank)],
      @sale.errors[:seller_id]
    assert_equal [error_message_from_model(@sale, :total_price, :blank)],
      @sale.errors[:total_price]
  end

  test 'validate format' do
    @sale.total_price = 'rock'

    assert @sale.invalid?
    assert_equal [error_message_from_model(@sale, :total_price, :not_a_number)],
      @sale.errors[:total_price]
  end
end
