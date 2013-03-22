module TransferProductsHelper
  def place_select_for_transfer_product(form)
    form.input :place_id, collection: Place.all.map { |p| [p.description, p.id] },
      include_blank: false, selected: Place.transfer_default.try(:id)
  end
end
