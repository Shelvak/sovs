class PrintController < ApplicationController
  def low_stock
    # Printer.print_low_stock_products

    respond_to do |format|
      format.json { head :ok }
    end
  end
end
