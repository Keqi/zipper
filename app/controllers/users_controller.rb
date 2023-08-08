# frozen_string_literal: true

class UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    user = User.new(permitted_params)

    if user.save
      token = TokenManager.encode(payload: { id: user.id })
      render json: { token: }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  private

  def permitted_params
    params.permit(:username, :password)
  end
end
