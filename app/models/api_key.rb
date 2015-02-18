class ApiKey < ActiveRecord::Base
  belongs_to :user
  
  validates :user, presence: true
  validates :access_token, uniqueness: true

  before_create :generate_access_token
  before_create :generate_expires_at

  before_save :generate_access_token
  before_save :generate_expires_at

  def as_json(options={})
    super(only: [:access_token, :expires_at])
  end
  

  def expired?
    Time.now.to_i > self.expires_at
  end

  private
  
  # By default, tokens expire in 60 days
  def generate_expires_at
    self.expires_at = (Time.now + 60.days).to_i
  end

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

end
