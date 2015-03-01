
%w(bold.jpg exo.jpg jay-chou.jpg jiang-hui.png leehom-wang.jpg snsd.jpg x-tuts.jpg).each do |event_name|
  name = event_name.upcase.gsub('-', ' ')
  dot = event_name.index '.'
  name = name[0...dot]
  Event.create!(name: "#{name}", 
                organizer: "Brent Heeringa", 
                date: (DateTime.now + (60..90).to_a.sample.day),
                location: Faker::Address.city,
                description: "An absolute must-see",
                image_path: "/assets/#{event_name}",
                link: Faker::Internet.url,
                total_tickets: ((100..200).to_a.sample),
                tickets_sold: ((100..200).to_a.sample)
                )
end
                
                
user = User.create(name: 'kmc3', unix: 'kmc3', password: 'foobar')
user2 = User.create(name: 'rhk1', unix: 'rhk1', password: 'foobar')

a = ApiKey.create(user: user, expires_at: (Time.now + 60.days).to_i, access_token: SecureRandom.hex)

Event.all.each do |event|
  event.tickets << Fabricate(:ticket, user: user, event: event)
  event.tickets << Fabricate(:ticket, user: user2, event: event)
end
