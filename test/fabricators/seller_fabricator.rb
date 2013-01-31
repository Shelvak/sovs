Fabricator(:seller) do
  code        { 1000000 * rand }
  name        { Faker::Name.name }
  address     { Faker::Address.street_address }
  phone       { Faker::PhoneNumber.phone_number }
end
