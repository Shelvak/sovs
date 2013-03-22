require 'test_helper'

class TransferProductTest < ActiveSupport::TestCase
  def setup
    @transfer_product = Fabricate(:transfer_product)
  end

  test 'create' do
    assert_difference 'TransferProduct.count' do
      assert_difference 'Version.count', 3 do
        TransferProduct.create(Fabricate.attributes_for(
          :transfer_product,
          place_id: @transfer_product.place_id,
          transfer_lines: @transfer_product.transfer_lines
        ))
      end 
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'TransferProduct.count' do
        assert @transfer_product.update_attributes(place_id: 1)
      end
    end

    assert_equal 1, @transfer_product.reload.place_id
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('TransferProduct.count', -1) { @transfer_product.destroy }
    end
  end
end
