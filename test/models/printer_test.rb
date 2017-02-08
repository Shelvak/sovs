require 'test_helper'

class PrinterTest < ActiveSupport::TestCase
  setup do
    #@printer = Cups.show_destinations.select {|p| p =~ /pdf/i}.first

    #raise "Can't find a PDF printer to run tests with." unless @printer
  end

  test 'should print daily report' do
    #assert_difference 'Cups.all_jobs(@printer).keys.sort.last' do
    #  assert Printer.print_daily_report(Date.today)
    #end
  end

  test 'should print tax' do
    sale = Fabricate(:product_line).sale
    assert Printer.print_tax(sale)
  end
end

