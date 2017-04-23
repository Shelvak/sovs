require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  def setup
    @customer = Fabricate(:customer)
  end

  test 'create' do
    assert_difference ['Customer.count', 'PaperTrail::Version.count'] do
      @customer = Customer.create(Fabricate.attributes_for(:customer))
    end 
  end
    
  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Customer.count' do
        assert @customer.update_attributes(name: 'Updated')
      end
    end

    assert_equal 'Updated', @customer.reload.name
  end
    
  test 'destroy' do 
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Customer.count', -1) { @customer.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @customer.iva_kind = ''
    @customer.bill_kind = ''
    
    assert @customer.invalid?
    assert_equal 2, @customer.errors.size
    assert_equal [error_message_from_model(@customer, :iva_kind, :blank)],
      @customer.errors[:iva_kind]
    assert_equal [error_message_from_model(@customer, :bill_kind, :blank)],
      @customer.errors[:bill_kind]
  end
    
  test 'validates unique attributes' do
    new_customer = Fabricate(:customer)
    @customer.cuit = new_customer.cuit
    @customer.business_name = new_customer.business_name

    assert @customer.invalid?
    assert_equal 2, @customer.errors.size
    assert_equal [error_message_from_model(@customer, :cuit, :taken)],
      @customer.errors[:cuit]
    assert_equal [error_message_from_model(@customer, :business_name, :taken)],
      @customer.errors[:business_name]
  end

  test 'validate customer kind' do
    @customer.name = ''
    @customer.business_name = ''

    assert @customer.invalid?
    assert_equal 1, @customer.errors.size
    assert_equal [error_message_from_model(@customer, :name, :blank)],
      @customer.errors[:name]

    @customer.business_name = 'Some'
    @customer.cuit = ''

    assert @customer.invalid?
    assert_equal 1, @customer.errors.size
    assert_equal [error_message_from_model(@customer, :cuit, :blank)],
      @customer.errors[:cuit]
  end
end
