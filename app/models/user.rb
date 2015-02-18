class User < ActiveRecord::Base

  has_one :api_key, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :password, presence: true, uniqueness: true

  def self.with_access_token(token)
    keys = ApiKey.where(access_token: token)
    key = keys ? keys.first : nil
    return key ? key.user : nil
  end

end
