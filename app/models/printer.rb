class Printer
  require 'prawn'

  class << self
    def print_tax(sale)
      start_printer

      title_print(I18n.t('printer.tax_worthless'))

      normal_print I18n.t('printer.seller', seller: sale.seller.code)
     
      separator_print

      sale.product_lines.each do |pl|
        compact_print(
          [
            [
              suit_string_length(pl.quantity.round(3), 8),
              suit_string_length(pl.product.purchase_unit, 2)
            ].join(' '),
            suit_string_length(pl.product.to_s.upcase, 38, true),
            round_and_stringlify(pl.unit_price),
            '->',
            round_and_stringlify(pl.price)
          ].join(' ')
        )
      end

      unless sale.common_bill?
        neto = sale.total_price / 1.21
        compact_print(
          [
            suit_string_length("#{sale.product_lines.size} Items", 10),
            suit_string_length('------------------------------->> Neto $', 38),
            suit_string_length('  ', 8),
            round_and_stringlify(neto)
          ].join(' ')
        )
        compact_print(
          [
            suit_string_length(' ', 15),
            suit_string_length('I.V.A. 21.00 %   $', 30),
            suit_string_length(' ', 12),
            suit_string_length((sale.total_price - neto).round(2), 8)
          ].join(' ')
        )
      end

      separator_print

      title_print I18n.t(
        'printer.total_price',
        total: number_to_currency(sale.total_price).to_s  #.gsub('$', '\$')
      )

      end_print
    end

    def print_daily_report(day)
      sellers = [[
        Sale.human_attribute_name('seller_code'),
        ProductLine.human_attribute_name('quantity'),
        ProductLine.human_attribute_name('price')
      ]]
      total_price = 0.00

      Seller.order.each do |seller|
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

    def print_payrolls(date)
      payrolls = [[
        I18n.t('view.stats.payrolls.days'),
        Seller.scoped.map { |s| I18n.t('view.stats.payrolls.seller_number', seller: s.code) },
        I18n.t('label.total')
      ].flatten]

      payrolls << [
        '  ',
        ([ 
          I18n.t('view.stats.payrolls.quantity-total')
        ] * (Seller.count + 1)),
      ].flatten

      from, to = date.beginning_of_month.to_date, date.end_of_month.to_date
      total_count = 0
      total_money = 0.0

      (from..to).each do |d|
        day_total = { count: 0, money: 0.0 }

        sellers_day_row = Seller.order.map do |s|
          s.count_and_sold_of_sales_on_day(d)
        end

        day_count = sellers_day_row.sum(&:first)
        day_money = sellers_day_row.sum(&:last).round(2)

        total_count += day_count
        total_money += day_money

        payrolls << [
          I18n.l(d, format: :abbr_for_payrolls).upcase,
          sellers_day_row.map{ |s| [s.first, s.last].join(' | ') },
          [day_count, day_money].join(' | ')
        ].flatten
      end

      total_table = []

      total_table << [
        I18n.t('view.stats.payrolls.abbr_quantity'),
        Seller.order.map { |s| s.sales.in_month(date).count },
        total_count
      ].flatten

      total_table << [
        I18n.t('view.stats.payrolls.money'),
        Seller.order.map { |s| number_to_currency(s.sales.in_month(date).sum(&:total_price)) },
        number_to_currency(total_money)
      ].flatten

      total_table << [
        '%',
        Seller.order.map do |s|
          (s.sales.in_month(date).sum(&:total_price) / total_money * 100).round(2)
        end
      ].flatten

      file_name = "payrolls_#{date}.pdf"
      folders = ['private', 'to_print'].join('/')
      file = [folders, file_name].join('/')

      generated = Prawn::Document.generate(
        file, page_size: 'A4', margin: 15
      ) do |pdf|

        pdf.font_size 9
        pdf.text [
          I18n.t('view.stats.payrolls.title'),
          I18n.t('view.stats.payrolls.for_month', month: date)
        ].join(' '), size: 14
        
        pdf.table payrolls, width: 800, cell_style: { 
          padding: [1, 3], height: 15, borders: [:right]
        } 

        pdf.table total_table, width: 800, cell_style: { 
          padding: [1, 3], height: 15, borders: [:right, :top, :bottom]
        }
      end

      send_to_print(file, landscape: true) if generated
    end

    # Retocar con echo
    def print_transfer_report(transfer)
      product_lines = [[
        TransferLine.human_attribute_name('product_id'),
        TransferLine.human_attribute_name('quantity'),
        TransferLine.human_attribute_name('price')
      ]]

      transfer.transfer_lines.each do |tl| 
        product_lines << [
          tl.product.to_s, 
          [tl.quantity, tl.product.retail_unit].join(' '),
          tl.price.to_f.round(3)
        ]
      end

      file_name = "transfer_report_#{I18n.l(Time.now, format: :for_file)}.pdf"
      folders = ['private', 'to_print'].join('/')
      file = [folders, file_name].join('/')
      height = ((transfer.transfer_lines.count * 20 + 100) * 3).round
      height = height > 612 ? height : 613
      print_height = transfer.transfer_lines.count * 10 + 157

      generated = Prawn::Document.generate(
        file, page_size: [612, height], left_margin: 19
      ) do |pdf|

        pdf.text I18n.l(Time.now, format: :long), size: 12
        pdf.move_down(5)

        pdf.font_size 12
        pdf.text "<i>#{I18n.t('printer.tax_worthless')}</i>", 
          size: 32, inline_format: true
        pdf.move_down(5)

        pdf.text I18n.t(
          'printer.transfer_stock', 
          day: I18n.l(Date.today, format: :for_report),
          place: transfer.place.to_s
        )
        pdf.move_down(20)
        
        pdf.table product_lines, width: 295
        pdf.move_down(5)

        pdf.text [I18n.t('label.total'), transfer.total_price].join(': ')
      end

      send_to_print(file, length: print_height) if generated
    end

    def number_to_currency(number)
      ActionController::Base.helpers.number_to_currency(number)
    end

    def send_to_print(file, options={})
      options[:length] ||= 279
      options[:length] = (options[:length] > 220) ? options[:length] : 220
      options[:width] ||= 100
      size = [options[:width], options[:length]].join('x')

      land = '-o landscape' if options[:landscape]

      %x{lp -o media=Custom.#{size}mm #{land} #{file}}
    end

    def set_correct_spaces(string, length)
      suit_string_length(string, length)
    end

    def suit_string_length(string, num, to_right = false)
      sign = to_right ? '-' : nil
      "%#{sign}#{num}.#{num}s" % string.to_s
    end

    def round_and_stringlify(int)
      suit_string_length('%.02f' % int, 7)
    end

    def start_printer
      print_with_script "\e@" 
    end

    def compact_print(string)
     print_with_script "\n\x1B\x21\x04  #{string}"
    end

    def title_print(string)
      print_with_script "\n\x1B\x21\x20  #{string}"
    end

    def normal_print(string)
      print_with_script "\n\x1B\x21\x01  #{string}"
    end

    def print_with_script(esc_pos)
      system(Rails.root.join('print_escaped_strings').to_s, esc_pos)
    end

    def separator_print
      normal_print '-' * 50
    end

    def end_print
      14.times { print_with_script "\n" }
    end
  end
end
