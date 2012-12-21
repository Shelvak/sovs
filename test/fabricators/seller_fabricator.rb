Fabricator(:seller) do
  code { 100 * rand }
  name { Faker::Name.name }
  address { Faker::Lorem.sentence }
  phone { Faker::Lorem.sentence }
end
