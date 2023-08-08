# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilesController, type: :request do
  let!(:file) { fixture_file_upload('test.txt') }
  let!(:user) { create(:user, username: 'maciej.nowak', password: 'Abcde12345!!') }

  describe '#create' do
    context 'when user was unauthorized' do
      before do
        post upload_path, params: { file: }, headers: { 'Authorization' => 'Bearer invalid-token' }
      end

      it 'does not upload the file' do
        expect(user.files.attachments.count).to eq(0)
      end

      it 'returns 403 unauthorized status with no body' do
        expect(response.status).to eq(403)
        expect(response.body).to eq('')
      end
    end

    context 'when user was authorized' do
      let!(:token) { sign_in(username: user.username, password: 'Abcde12345!!') }

      before do
        post upload_path, params: { file: }, headers: { 'Authorization' => "Bearer #{token}" }
      end

      after { FileUtils.rm_rf(ActiveStorage::Blob.service.root) }

      it 'successfully uploads the file' do
        expect(user.files.attachments.count).to eq(1)
      end

      it 'returns 200 with successful message' do
        body = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(body['message']).to eq('You have successfully uploaded the file.')
      end
    end
  end
end
