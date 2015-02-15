class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :password, presence: true, uniqueness: true
end
