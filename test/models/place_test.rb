require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  def setup
    @place = Fabricate(:place)
  end

  test 'create' do
    assert_difference ['Place.count', 'PaperTrail::Version.count'] do
      @place = Place.create(Fabricate.attributes_for(:place))
    end 
  end
    
  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Place.count' do
        assert @place.update_attributes(description: 'Updated')
      end
    end

    assert_equal 'Updated', @place.reload.description
  end
    
  test 'destroy' do 
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Place.count', -1) { @place.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @place.description = ''
    
    assert @place.invalid?
    assert_equal 1, @place.errors.size
    assert_equal [error_message_from_model(@place, :description, :blank)],
      @place.errors[:description]
  end
    
  test 'validates unique attributes' do
    new_place = Fabricate(:place)
    @place.description = new_place.description

    assert @place.invalid?
    assert_equal 1, @place.errors.size
    assert_equal [error_message_from_model(@place, :description, :taken)],
      @place.errors[:description]
  end

  test 'keep only one transfer defalt' do
    @place = Fabricate(:place, transfer_default: true)
    
    assert_not_nil Place.transfer_default
    assert_equal Place.transfer_default, @place

    new_default = nil
    assert_difference 'Place.count' do
      new_default = Fabricate(:place, transfer_default: true)
    end

    assert_not_nil Place.transfer_default
    assert_not_equal Place.transfer_default, @place
    assert_equal Place.transfer_default, new_default
  end
end
