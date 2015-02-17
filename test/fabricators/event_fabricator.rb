Fabricator(:event) do
  name           { Faker::Name.first_name }
  organizer      { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
  date           { Date.today }
  location       { "#{Faker::Address.city}" }
  description    { "an awesome concert" }
  link           { ['/assets/tiesto.jpg', '/assets/daft_punk.jpg'].sample }
  total_tickets  { (100..200).to_a.sample }
  tickets_sold   { (50..75).to_a.sample }
end
