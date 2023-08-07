# frozen_string_literal: true

class SessionsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    user = User.find_by(username: permitted_params[:username])

    if user&.authenticate(permitted_params[:password])
      session[:user_id] = user.id
      render json: { message: 'You have been successfully signed in.' }, status: :ok
    else
      render json: { errors: 'The username/password combination is invalid.' }, status: :bad_request
    end
  end

  def destroy
    if current_user
      session[:user_id] = nil
      render json: { message: 'You have been successfully signed out.' }, status: :ok
    else
      render json: { errors: 'You are already signed out.' }, status: :bad_request
    end
  end

  private

  def permitted_params
    params.permit(:username, :password)
  end
end
