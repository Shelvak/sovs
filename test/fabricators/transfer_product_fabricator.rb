Fabricator(:transfer_product) do
  place_id { Fabricate(:place).id }
  transfer_lines do 
    [TransferLine.new(
      Fabricate.attributes_for(:transfer_line, transfer_product_id: nil)
    )]
  end
end
