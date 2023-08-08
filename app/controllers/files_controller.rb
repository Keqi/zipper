# frozen_string_literal: true

require 'zip'

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
    file_zipper = FileZipper.new(input_file: params[:file])
    file_zipper.zip

    if @current_user.files.attach(io: file_zipper.file, filename: File.basename(file_zipper.file.path))
      file = @current_user.files.attachments.order(created_at: :desc).first

      render json: {
        password: file_zipper.password,
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
