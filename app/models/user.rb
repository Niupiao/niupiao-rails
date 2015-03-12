class User < ActiveRecord::Base

  has_one :facebook_identity, dependent: :destroy

  has_one :api_key, dependent: :destroy
  has_many :tickets
  has_many :events, through: :tickets

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true

  after_save :create_api_key

  def self.with_facebook_id(facebook_id)
    identities = FacebookIdentity.where(facebook_id: facebook_id)
    identity = identities ? identities.first : nil
    return identity ? identity.user : nil
  end
  
  def self.with_access_token(token)
    keys = ApiKey.where(access_token: token)
    key = keys ? keys.first : nil
    return key ? key.user : nil
  end

  def as_json(options={})
    if options
      super(options)
    else
      super(include: [:events])
    end
  end

  def my_tickets
    json = []
    events.each do |event|
      hash = event.as_json
      my_tickets = event.tickets.owned_by(self)
      hash['tickets'] = my_tickets.as_json
      json << hash
    end
    json.as_json
  end

  
  private

  def create_api_key
    ApiKey.create!(user: self)
    #ApiKey.create(user: self, expires_at: (Time.now + 60.days).to_i, access_token: SecureRandom.hex)
  end

end
