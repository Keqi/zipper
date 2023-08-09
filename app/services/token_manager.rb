# frozen_string_literal: true

class TokenManager
  def self.encode(payload:)
    exp_payload = payload.merge({ exp: expiration_time })
    JWT.encode(exp_payload, secret, 'HS256')
  end

  def self.decode(token:)
    JWT.decode(token, secret, true, { algorithm: 'HS256' })
  end

  def self.expiration_time
    Time.now.to_i + 4.hours.to_i
  end

  def self.secret
    Rails.application.credentials.dig(:jwt, :secret)
  end
end
