# frozen_string_literal: true

module AuthenticationSpecHelper
  def as_signed_in_user(user:)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  def sign_in(username:, password:)
    post sign_in_path, params: { username:, password: }
    JSON.parse(response.body)['token']
  end
end
