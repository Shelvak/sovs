class Printer
  require 'prawn'

  class << self
    def print_tax(sale)
      start_printer
      print_tax_worthless
      normal_print I18n.t('printer.seller', seller: sale.seller.code)
     
      separator_print

      sale.product_lines.each do |pl|
        descript = pl.product.to_s.upcase
        descript += ' Pz' if pl.price_type == 'unit_price'
        descript += ' Es' if pl.price_type == 'special_price'
        compact_print(
          [
            [
              suit_string_length(pl.quantity.round(3), 8),
              suit_string_length(pl.product.purchase_unit, 2)
            ].join(' '),
            suit_string_length(descript, 38, true),
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
            suit_string_length('  ', 11),
            round_and_stringlify(neto)
          ].join(' ')
        )
        compact_print(
          [
            suit_string_length(' ', 15),
            suit_string_length('I.V.A. 21.00 %   $', 30),
            suit_string_length(' ', 13),
            suit_string_length('%.02f' % (sale.total_price - neto), 8)
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
      start_printer
      print_tax_worthless
      title_print(I18n.t('view.sales.daily_report'))
      title_print I18n.l(day)
      separator_print

      compact_print [
        suit_string_length(Sale.human_attribute_name('seller_id'), 8),
        suit_string_length(ProductLine.human_attribute_name('quantity'), 8),
        suit_string_length(ProductLine.human_attribute_name('price'), 14),
        suit_string_length(I18n.t('shared.average'), 14)
      ].join(' | ')

      total_price = 0.00
      sales_count = 0

      Seller.order(:code).each do |seller|
        sales_of_day = seller.sales.in_day(day)
        seller_day_sum = sales_of_day.sum(&:total_price)
        total_price += seller_day_sum
        sales_count += sales_of_day.positives.count
        average = sales_of_day.count > 0 ? seller_day_sum / sales_of_day.count : 0

        compact_print [
          suit_string_length(seller.code, 8),
          suit_string_length(sales_of_day.count, 8),
          suit_string_length(number_to_currency(seller_day_sum), 14),
          suit_string_length(number_to_currency(average), 14)
        ].join(' | ')
      end

      separator_print
      total_average = sales_count > 0 ? total_price / sales_count : 0

      black_print [
        I18n.t(
          'printer.total_sales_count',
          sales_count: sales_count,
          total_price: number_to_currency(total_price)
        ),
        "\n  #{I18n.t('shared.average')}:",
        number_to_currency(total_average)
      ].join(' ')

      end_print
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

    def print_transfer_report(transfer)
      start_printer
      print_tax_worthless
      title_print I18n.t(
        'printer.transfer_stock', 
        day: I18n.l(Date.today),
        place: transfer.place.to_s
      )

      separator_print

      compact_print [
        suit_string_length(' ', 5),
        suit_string_length(TransferLine.human_attribute_name('product_id'), 28, true),
        suit_string_length(TransferLine.human_attribute_name('quantity'), 10),
        suit_string_length(ProductLine.human_attribute_name('unit_price_abbr'), 10),
        suit_string_length(TransferLine.human_attribute_name('price'), 10)
      ].join(' ')

      transfer.transfer_lines.each do |tl| 
        compact_print [
          suit_string_length(' ', 5),
          suit_string_length(tl.product.to_s, 28, true), 
          suit_string_length([tl.quantity, tl.product.retail_unit].join(' '), 10),
          suit_string_length(number_to_currency(tl.price), 10),
          suit_string_length(number_to_currency(tl.price * tl.quantity), 10)
        ].join(' ')
      end

      separator_print

      title_print [
        I18n.t('label.total'), number_to_currency(transfer.total_price)
      ].join(': ')

      end_print
    end

    def print_low_stock_products
      start_printer
      print_tax_worthless
      compact_print [
        I18n.t('view.products.low_stock'),
        I18n.l(Date.today)
      ].join('  ')

      separator_print

      compact_print [
        suit_string_length(
          Product.human_attribute_name('description').gsub('ó', 'o'), 20
        ),
        suit_string_length(Product.human_attribute_name('total_stock'), 20)
      ].join(' | ')

      Product.with_low_stock.with_recent_sales.
        group_by(&:provider_id).each do |provider, products|
        
        black_print Provider.find(provider).name

        products.sort_by { |p| p.code }.each do |p|
          compact_print [
            suit_string_length(p.to_s, 20),
            suit_string_length(
              [p.total_stock, p.retail_unit].join(' '), 20
            )
          ].join(' | ')
        end
      end

      separator_print

      end_print
    end

    private

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

    def black_print(string)
      print_with_script "\n\x1B\x21\x08  #{string}"
    end

    def normal_print(string)
      print_with_script "\n\x1B\x21\x01  #{string}"
    end

    def print_with_script(esc_pos)
      system(Rails.root.join('print_escaped_strings').to_s, esc_pos)
      #%x{echo -en "#{esc_pos}" >> impresiones}
    end

    def separator_print
      normal_print '-' * 50
    end

    def end_print
      14.times { print_with_script "\n" }
    end

    def print_tax_worthless
      title_print(I18n.t('printer.tax_worthless'))
    end
  end
end
