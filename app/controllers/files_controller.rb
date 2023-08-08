# frozen_string_literal: true

class FilesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authorize

  def index
    files = @current_user.files.map do |file|
      {
        created_at: file.created_at,
        filename: file.blob.filename,
        link: rails_blob_url(file, disposition: 'attachment')
      }
    end

    render json: { files: }, status: :ok
  end

  def create
    if @current_user.files.attach(permitted_params[:file])
      file = @current_user.files.attachments.order(created_at: :desc).first

      render json: {
        link: rails_blob_url(file, disposition: 'attachment'),
        message: 'You have successfully uploaded the file.'
      }, status: :ok
    else
      render json: { errors: 'Something went wrong.' }, status: :bad_request
    end
  end

  private

  def permitted_params
    params.permit(:file)
  end
end
