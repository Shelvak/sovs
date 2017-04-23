require 'test_helper'

class ProviderTest < ActiveSupport::TestCase
  def setup
    @provider = Fabricate(:provider)
  end

  test 'create' do
    assert_difference ['Provider.count', 'PaperTrail::Version.count'] do
      @provider = Provider.create(Fabricate.attributes_for(:provider))
    end 
  end
    
  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Provider.count' do
        assert @provider.update_attributes(name: 'Updated')
      end
    end

    assert_equal 'Updated', @provider.reload.name
  end
    
  test 'destroy' do 
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Provider.count', -1) { @provider.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @provider.name = ''
    @provider.cuit = ''
    
    assert @provider.invalid?
    assert_equal 2, @provider.errors.size
    assert_equal [error_message_from_model(@provider, :name, :blank)],
      @provider.errors[:name]
    assert_equal [error_message_from_model(@provider, :cuit, :blank)],
      @provider.errors[:cuit]
  end
    
  test 'validates unique attributes' do
    new_provider = Fabricate(:provider)
    @provider.cuit = new_provider.cuit

    assert @provider.invalid?
    assert_equal 1, @provider.errors.size
    assert_equal [error_message_from_model(@provider, :cuit, :taken)],
      @provider.errors[:cuit]
  end

  test 'increase all products price' do
    3.times do
      Fabricate(
        :product, provider_id: @provider.id,
        cost: 10,
        iva_cost: 10,
        gain: 10,
        retail_price: 11,
        unit_price: 11,
        special_price: 11
      )
    end
  
    assert_difference 'PaperTrail::Version.count', 3 do
      assert_no_difference ['Provider.count', 'Product.count'] do
        @provider.increase_all_products!(10)
      end
    end
    @provider.products.each do |product|
      assert_equal 11, product.cost
      assert_equal 11, product.iva_cost
      assert_equal 12.1, product.retail_price
      assert_equal 12.1, product.unit_price
      assert_equal 12.1, product.special_price
    end
  end
end
