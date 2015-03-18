
%w(bold.jpg exo.jpg jay-chou.jpg jiang-hui.png leehom-wang.jpg snsd.jpg x-tuts.jpg).each do |event_name|
  name = event_name.upcase.gsub('-', ' ')
  dot = event_name.index '.'
  name = name[0...dot]
  e = Event.create!(name: "#{name}", 
                organizer: "Brent Heeringa", 
                date: (DateTime.now + (60..90).to_a.sample.day),
                location: Faker::Address.city,
                description: "An absolute must-see",
                image_path: "/assets/#{event_name}",
                link: Faker::Internet.url,
                total_tickets: 0,
                tickets_sold: 0)
  e.ticket_statuses << TicketStatus.create!(name: "General", max_purchasable: 3, price: 50)
  e.ticket_statuses << TicketStatus.create!(name: "VIP",     max_purchasable: 2, price: 150)
  e.save!
end
                
                
user1 = User.create(email: 'kmc3@williams.edu', password: 'foobar', name: 'Kevin Chen', first_name: 'Kevin', last_name: 'Chen')
user2 = User.create(email: 'rhk1@williams.edu', password: 'foobar', name: 'Ryan Kwon', first_name: 'Ryan', last_name: 'Kwon')

Event.all.each do |event|
  User.all.each do |user|
    event.ticket_statuses.each do |ticket_status|
      event.tickets << Ticket.create!(event: event, ticket_status: ticket_status, user: user)
      event.tickets << Ticket.create!(event: event, ticket_status: ticket_status)
      event.save!
    end
  end
end
