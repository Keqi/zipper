# frozen_string_literal: true

class User < ApplicationRecord
  PASSWORD_FORMAT = /\A
    (?=.*[A-Z]) # Must contain an uppercase character
    (?=.*[a-z]) # Must contain a lowercase character
    (?=.*\d) # Must contain a digit
  /x

  has_many_attached :files

  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 12 },
                       format: { with: PASSWORD_FORMAT, message: 'must include: 1 uppercase, 1 lowercase and 1 digit' },
                       unless: proc { |x| x.password.blank? }

  has_secure_password
end
