Fabricator(:provider) do
  name        { Faker::Name.name }
  contact     { Faker::Name.name }
  address     { Faker::Address.street_address }
  cuit        { (10000000000 * rand).to_i }
  phone       { Faker::PhoneNumber.phone_number }
end