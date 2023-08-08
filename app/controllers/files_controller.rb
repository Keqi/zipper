# frozen_string_literal: true

class FilesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authorize

  def create
    if @current_user.files.attach(permitted_params[:file])
      render json: { message: 'You have successfully uploaded the file.' }, status: :ok
    else
      render json: { errors: 'Something went wrong.' }, status: :bad_request
    end
  end

  private

  def permitted_params
    params.permit(:file)
  end
end
