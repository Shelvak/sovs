Fabricator(:seller) do
  code        { 100 * rand }
  name        { Faker::Name.name }
  address     { Faker::Address.street_address }
  phone       { Faker::PhoneNumber.phone_number }
end
