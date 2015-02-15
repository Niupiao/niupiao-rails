Fabricator(:event) do
  name           { Faker::Name.first_name }
  organizer      { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
  date           {}
  location       {}
  description    {}
  link           {}
  total_tickets  {}
  tickets_sold   {}
end
