class Manager < ActiveRecord::Base
    before_save { self.email = email.downcase }
    validates :organization, presence: true
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true,
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, length: { minimum: 6 }
    
    has_many :events, dependent: :destroy
    
    accepts_nested_attributes_for :events, 
                                #Rejects ticket statuses with blank names as an extra precaution.
                                reject_if: lambda { |status| status[:name].blank? }, 
                                allow_destroy: true #Ticket statuses can be destroyed.
end
