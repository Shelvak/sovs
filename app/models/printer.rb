class Printer
  require 'prawn'

  class << self
    def print_common_tax(sale)
      file_name = "#{sale.id}_#{I18n.l(Time.now, format: :for_file)}.pdf"
      folders = ['private', 'to_print'].join('/')
      file = [folders, file_name].join('/')
      # Lines count * 20mm + 100mm(title and footer) * 3(size)
      doc_height = ((sale.product_lines.size * 20 + 150) * 3).round
      print_height = sale.product_lines.size * 12 + 120

      generated = Prawn::Document.generate(
        file, page_size: [612, doc_height], left_margin: 17
      ) do |pdf|

        pdf.font_size 10
        pdf.text I18n.l(Time.now, format: :long)
        pdf.move_down(5)
        pdf.text "<i>#{I18n.t('printer.tax_worthless')}</i>", size: 30, inline_format: true
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

        pdf.table(items, cell_style: { align: :right }, width: 295) do
          column(0).align = :left
        end

        pdf.move_down(5)
        pdf.text I18n.t(
          'printer.items_count_with_net_price', count: sale.product_lines.size,
          price: number_to_currency(sale.total_price)
        )
        
        pdf.move_down(10)
        pdf.text I18n.t(
          'printer.total_price', 
          total: number_to_currency(sale.total_price)
        ), size: 20
        
        pdf.move_down(25)
        pdf.text I18n.t('printer.thinks'), size: 20
      end

      send_to_print(file, length: print_height) if generated
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
      height = ((Seller.count * 20 + 100) * 3).round
      print_height = Seller.count * 10 + 157

      generated = Prawn::Document.generate(
        file, page_size: [612, height], left_margin: 19
      ) do |pdf|

        pdf.font_size 15
        pdf.text "<i>#{I18n.t('printer.tax_worthless')}</i>", size: 32, inline_format: true
        pdf.move_down(5)

        pdf.text I18n.t('printer.daily_sales_report_for', day: I18n.l(day, format: :for_report))
        pdf.move_down(20)
        
        pdf.table sellers, width: 295
        pdf.move_down(5)

        pdf.text I18n.t(
          'printer.total_sales_count',
          sales_count: sales_count,
          total_price: number_to_currency(total_price)
        )
      end

      send_to_print(file, length: print_height) if generated
    end

    def number_to_currency(number)
      ActionController::Base.helpers.number_to_currency(number)
    end

    def send_to_print(file, options={})
      options[:length] = 279  if options[:length].blank?
      options[:length] = (options[:length] > 220) ? options[:length] : 220
      options[:width] ||= 216
      size = [options[:width], options[:length]].join('x')

      %x{lp -o media=Custom.#{size}mm #{file}}
    end
  end
end
