Fabricate.times(10, :event)

user = User.create(name: 'kmc3', unix: 'kmc3', password: 'foobar')

a = ApiKey.create(user: user, expires_at: (Time.now + 60.days).to_i, access_token: SecureRandom.hex)
