# frozen_string_literal: true

module AuthenticationSpecHelper
  def sign_in(username:, password:)
    post tokens_path, params: { username:, password: }
    JSON.parse(response.body)['token']
  end
end
