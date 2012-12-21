Fabricator(:customer) do
  name          { Faker::Name.name }
  business_name { Faker::Name.name }
  iva_kind      { Customer::KINDS.values.sample }
  bill_kind     { Customer::BILL_KINDS.sample }
  address       { Faker::Address.street_address }
  cuit          { (10000000000 * rand).to_i }
  phone         { Faker::PhoneNumber.phone_number }
end
