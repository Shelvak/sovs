require 'test_helper'

class SellerTest < ActiveSupport::TestCase
  def setup
    @seller = Fabricate(:seller)
  end

  test 'create' do
    assert_difference ['Seller.count', 'PaperTrail::Version.count'] do
      @seller = Seller.create(Fabricate.attributes_for(:seller))
    end 
  end
    
  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Seller.count' do
        assert @seller.update_attributes(name: 'Updated')
      end
    end

    assert_equal 'Updated', @seller.reload.name
  end
    
  test 'destroy' do 
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Seller.count', -1) { @seller.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @seller.code = ''
    @seller.name = ''

    assert @seller.invalid?
    assert_equal 2, @seller.errors.size
    assert_equal [error_message_from_model(@seller, :code, :blank)],
      @seller.errors[:code]
    assert_equal [error_message_from_model(@seller, :name, :blank)],
      @seller.errors[:name]
  end
    
  test 'validates unique attributes' do
    new_seller = Fabricate(:seller)
    @seller.code = new_seller.code

    assert @seller.invalid?
    assert_equal 1, @seller.errors.size
    assert_equal [error_message_from_model(@seller, :code, :taken)],
      @seller.errors[:code]
  end
end
