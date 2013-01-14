class Printer
  require 'prawn'

  class << self
    def print_common_tax(sale)
      file_name = "#{sale.id}_#{I18n.l(Time.now, format: :for_file)}.pdf"
      folders = ['private', 'to_print'].join('/')
      file = [folders, file_name].join('/')

      generated = Prawn::Document.generate(file) do |pdf|
        pdf.font_size 15
        pdf.text "<i>#{I18n.t('printer.tax_worthless')}</i>", size: 32, inline_format: true
        pdf.move_down(5)
        
        pdf.text I18n.t('printer.seller', seller: sale.seller.code)
        pdf.move_down(20)

        items = [[
          ProductLine.human_attribute_name('product_id'),
          ProductLine.human_attribute_name('quantity'),
          ProductLine.human_attribute_name('unit_price_abbr'),
          ProductLine.human_attribute_name('partial_price')
        ]]

        sale.product_lines.each do |pl|
          items << [
            pl.product.to_s,
            "#{pl.quantity} #{pl.product.purchase_unit}",
            number_to_currency(pl.product.retail_price),
            number_to_currency(pl.price)
          ]
        end

        pdf.table(items, cell_style: { align: :right }) do
          column(0).align = :left
        end

        pdf.move_down(5)
        pdf.text I18n.t(
          'printer.items_count_with_net_price', count: sale.product_lines.count,
          price: number_to_currency(sale.total_price)
        )
        
        pdf.move_down(10)
        pdf.text I18n.t(
          'printer.total_price', 
          total: number_to_currency(sale.total_price)
        ), size: 20
        
        pdf.move_down(25)
        pdf.text I18n.t('printer.thinks'), size: 32
      end

      send_to_print(file) if generated
    end

    def print_daily_report(day)
      sellers = [[
        Seller.human_attribute_name('code'),
        ProductLine.human_attribute_name('quantity'),
        ProductLine.human_attribute_name('price')
      ]]
      total_price = 0.00

      Seller.all.each do |seller|
        sales_of_day = seller.sales.in_day(day)
        total_price += sales_of_day.sum(&:total_price)
        sellers << [
          seller.code,
          sales_of_day.count,
          number_to_currency(sales_of_day.sum(&:total_price))
        ]
      end
      sales_count = sellers.drop(1).sum(&:second)

      file_name = "sales_report_#{I18n.l(Time.now, format: :for_file)}.pdf"
      folders = ['private', 'to_print'].join('/')
      file = [folders, file_name].join('/')

      generated = Prawn::Document.generate(file) do |pdf|
        pdf.font_size 15
        pdf.text "<i>#{I18n.t('printer.tax_worthless')}</i>", size: 32, inline_format: true
        pdf.move_down(5)

        pdf.text I18n.t('printer.daily_sales_report_for', day: I18n.l(day, format: :for_report))
        pdf.move_down(20)
        
        pdf.table sellers
        pdf.move_down(5)

        pdf.text I18n.t(
          'printer.total_sales_count',
          sales_count: sales_count,
          total_price: number_to_currency(total_price)
        )
      end

      send_to_print(file) if generated
    end

    def number_to_currency(number)
      ActionController::Base.helpers.number_to_currency(number)
    end

    def send_to_print(file)
      %x{lp #{file}}
    end
  end
end
