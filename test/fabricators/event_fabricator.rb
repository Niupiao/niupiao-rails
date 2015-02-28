Fabricator(:event) do
  name           { Faker::Name.first_name }
  organizer      { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
  date           { DateTime.now + (60..90).to_a.sample.day }
  location       { "#{Faker::Address.city}" }
  description    { "an awesome concert" }
  image_path     { ['/assets/tiesto.jpg', '/assets/daft_punk.jpg'].sample }
  link           { Faker::Internet.url }
  total_tickets  { (100..200).to_a.sample }
  tickets_sold   { (50..75).to_a.sample }
end
