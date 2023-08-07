class User < ApplicationRecord
  PASSWORD_FORMAT = /\A
    (?=.*[A-Z]) # Must contain an uppercase character
    (?=.*[a-z]) # Must contain a lowercase character
    (?=.*\d) # Must contain a digit
  /x

  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 12 }
  validates :password,
            format: { with: PASSWORD_FORMAT,
                      message: 'must include: 1 uppercase, 1 lowercase, 1 digit and 1 special character' }

  has_secure_password
end