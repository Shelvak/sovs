module UsersHelper
  def show_user_roles_options(form)
    options = User.valid_roles.map { |r| [t("view.users.roles.#{r}"), r] }
    
    form.input :role, collection: options, as: :radio_buttons, label: false,
      input_html: { class: nil }
  end

  def place_selector_for_user(form)
    form.input :place_id, as: :select, 
      collection: Place.all.map{ |pl| [pl.description, pl.id] },
      selected: form.object.place_id, include_blank: true
  end
end
