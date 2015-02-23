Fabricate.times(10, :event)

user = User.create(name: 'kmc3', unix: 'kmc3', password: 'foobar')
user2 = User.create(name: 'rhk1', unix: 'rhk1', password: 'foobar')

a = ApiKey.create(user: user, expires_at: (Time.now + 60.days).to_i, access_token: SecureRandom.hex)

Event.all.each do |event|
  event.tickets << Fabricate(:ticket, user: user, event: event)
  event.tickets << Fabricate(:ticket, user: user2, event: event)
end
