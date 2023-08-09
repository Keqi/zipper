# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user = User.find_by(username: permitted_params[:username])

    if user&.authenticate(permitted_params[:password])
      token = TokenManager.encode(payload: { id: user.id })
      render json: { token: }, status: :ok
    else
      render json: { errors: 'The username/password combination is invalid.' }, status: :bad_request
    end
  end

  private

  def permitted_params
    params.permit(:username, :password)
  end
end
