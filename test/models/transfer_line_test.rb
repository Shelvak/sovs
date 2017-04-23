require 'test_helper'

class TransferLineTest < ActiveSupport::TestCase
  def setup
    @transfer_line = Fabricate(:transfer_line)
  end

  test 'create' do
    assert_difference 'TransferLine.count' do
      assert_difference 'PaperTrail::Version.count', 2 do
        TransferLine.create(
          Fabricate.attributes_for(
            :transfer_line,
            product_id: @transfer_line.product_id,
            transfer_product_id: @transfer_line.transfer_product_id
          )
        )
      end 
    end 
  end
    
  test 'update' do
    assert_difference 'PaperTrail::Version.count', 2 do
      assert_no_difference 'TransferLine.count' do
        assert @transfer_line.update_attributes(quantity: 3)
      end
    end

    assert_equal 3, @transfer_line.reload.quantity
  end
    
  test 'destroy' do 
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('TransferLine.count', -1) { @transfer_line.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @transfer_line.product_id = ''
    @transfer_line.quantity  = ''
    
    assert @transfer_line.invalid?
    assert_equal 2, @transfer_line.errors.size
    assert_equal [error_message_from_model(@transfer_line, :product_id, :blank)],
      @transfer_line.errors[:product_id]
    assert_equal [error_message_from_model(@transfer_line, :quantity, :blank)],
      @transfer_line.errors[:quantity]
  end

  test 'should discount stock' do
    product_stock = @transfer_line.product.total_stock.round(2)
    new_transfer_line = nil

    assert_difference 'TransferLine.count' do
      new_transfer_line = Fabricate(
        :transfer_line, transfer_product_id: @transfer_line.transfer_product_id,
        product_id: @transfer_line.product_id, quantity: 10
      )
    end

    assert_equal new_transfer_line.product.total_stock.to_f,
      (product_stock - 10).to_f
  end
end
