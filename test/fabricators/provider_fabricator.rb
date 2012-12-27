Fabricator(:provider) do
  name        { Faker::Name.name }
  contact     { Faker::Name.name }
  address     { Faker::Address.street_address }
  cuit        { (10000000000 * rand).to_i }
  phone       { Faker::PhoneNumber.phone_number }
  other_phone { Faker::PhoneNumber.cell_phone }
  fax         { Faker::PhoneNumber.phone_number }
  locality    { Faker::Address.city }
  city        { Faker::Address.city }
  province    { Faker::Address.state }
  postal_code { Faker::Address.zip_code }
end
