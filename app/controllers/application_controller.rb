# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def authorize
    token = request.headers['Authorization']

    head :forbidden unless token

    decoded_token = validate_token!(token)
    @current_user = User.find_by(id: decoded_token.first['id'])
  rescue JWT::DecodeError => e
    Rails.logger.warn "Error decoding the JWT: #{e}"
    head :forbidden
  end

  private

  def validate_token!(token)
    formatted_token = token.gsub('Bearer ', '')

    TokenManager.decode(token: formatted_token)
  end
end
