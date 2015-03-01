Fabricator(:event) do
  name           { Faker::Name.first_name }
  organizer      { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
  date           { DateTime.now + (60..90).to_a.sample.day }
  location       { "#{Faker::Address.city}" }
  description    { "an awesome concert" }
  image_path     { ['/assets/bold.jpg', '/assets/exo.jpg', '/assets/jay-chou.jpg', '/assets/jiang-hui.png', '/assets/leehom-wang.jpg', '/assets/snsd.jpg', '/assets/x-tuts.jpg'].sample }
  link           { Faker::Internet.url }
  total_tickets  { (100..200).to_a.sample }
  tickets_sold   { (50..75).to_a.sample }
end
