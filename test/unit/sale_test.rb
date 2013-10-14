require 'test_helper'

class SaleTest < ActiveSupport::TestCase
  def setup
    @sale = Fabricate(:sale)
  end

  test 'create' do
    assert_difference 'Sale.count' do
      assert_difference 'Version.count', 5 do
        Sale.create!(Fabricate.attributes_for(
          :sale, customer_id: @sale.customer_id, 
          seller_id: @sale.seller_id, place_id: @sale.place_id
        ))
      end 
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
    assert_difference 'Version.count', 2 do
      assert_difference('Sale.count', -1) { @sale.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @sale.seller_code = ''
    @sale.total_price = ''
    
    assert @sale.invalid?
    assert_equal 2, @sale.errors.size
    assert_equal [error_message_from_model(@sale, :seller_code, :blank)],
      @sale.errors[:seller_code]
    assert_equal [error_message_from_model(@sale, :total_price, :blank)],
      @sale.errors[:total_price]
  end

  test 'validate format' do
    @sale.total_price = 'rock'

    assert @sale.invalid?
    assert_equal [error_message_from_model(@sale, :total_price, :not_a_number)],
      @sale.errors[:total_price]

    @sale.reload
    @sale.sale_kind = 'rock'
    assert @sale.invalid?
    assert_equal [
      error_message_from_model(@sale, :sale_kind, :too_long, count: 1)
    ], @sale.errors[:sale_kind]
  end

  test 'discount stock in all product_lines' do
    sale_attrs = Fabricate.attributes_for(:sale, product_lines: nil)
    sale_attrs.delete(:product_lines)
    
    @sale = Sale.new(sale_attrs.merge(product_lines_attributes: { 
        new_1: Fabricate.attributes_for(:product_line, quantity: 1),
        new_2: Fabricate.attributes_for(:product_line, quantity: 1)
      }
    ))

    product_line_products_stock = @sale.product_lines.map { |pl| pl.product.total_stock - 1 }
    assert_difference 'Sale.count' do
      assert @sale.save!
    end

    reloaded_stock = @sale.reload.product_lines.map { |pl| pl.product.total_stock }
    assert_equal reloaded_stock.sort, product_line_products_stock.sort
  end

  test 'sum to stock when revoked' do
    sale = Fabricate(:sale)

    pl = sale.product_lines.first
    product = pl.product
    quantity = pl.quantity
    stock_after_sale = product.total_stock

    assert_no_difference ['Sale.count', 'Product.count'] do
      assert sale.revoke!
    end

    assert_equal (stock_after_sale + quantity).to_f, 
      product.reload.total_stock.to_f
  end

  test 'validate correct IVA discrimination' do
    sale = Fabricate(:sale, sale_kind: 'A')

    total_price = sale.product_lines.sum(&:price) * 1.21

    assert_equal total_price.to_f, sale.reload.total_price.to_f
  end

  test 'probe correct stock agregation' do
    sale = Fabricate(:sale, sale_kind: 'A')

    product = sale.product_lines.first.product
    old_stock = product.total_stock.to_f

    new_sale = Fabricate(:sale, product_lines: [
       ProductLine.new(Fabricate.attributes_for(:product_line,
         product_id: product.id, quantity: -5, sale_id: nil
       ))
    ])

    assert_equal (old_stock + 5).round(2),
      product.reload.total_stock.round(2)
  end
end
