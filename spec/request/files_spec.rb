# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilesController, type: :request do
  let!(:file) { fixture_file_upload('test.txt') }
  let!(:user) { create(:user, username: 'maciej.nowak', password: 'Abcde12345!!') }

  describe '#create' do
    context 'when user was unauthorized' do
      before do
        post files_path, params: { file: }, headers: { 'Authorization' => 'Bearer invalid-token' }
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

      context 'when no file has been uploaded' do
        before do
          post files_path, params: {}, headers: { 'Authorization' => "Bearer #{token}" }
        end

        it 'returns status 400 with error message' do
          body = JSON.parse(response.body)

          expect(response.status).to eq(400)
          expect(body['errors']).to eq('No file has been uploaded.')
        end
      end

      context 'when file has been uploaded' do
        before do
          post files_path, params: { file: }, headers: { 'Authorization' => "Bearer #{token}" }
        end

        it 'successfully uploads the file' do
          expect(user.files.attachments.count).to eq(1)
        end

        it 'returns status 200 with link and password to the zipped package' do
          body = JSON.parse(response.body)

          expect(response.status).to eq(200)
          expect(body['link']).to be
          expect(body['password']).to be
        end
      end
    end
  end

  describe '#index' do
    context 'when user was unauthorized' do
      before do
        get files_path, headers: { 'Authorization' => 'Bearer invalid-token' }
      end

      it 'returns 403 unauthorized status with no body' do
        expect(response.status).to eq(403)
        expect(response.body).to eq('')
      end
    end

    context 'when user was authorized' do
      let!(:token) { sign_in(username: user.username, password: 'Abcde12345!!') }

      before do
        user.files.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.txt')),
          filename: 'test.txt'
        )

        get files_path, headers: { 'Authorization' => "Bearer #{token}" }
      end

      it 'returns 200 with list of uploaded files' do
        body = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(body['files'].size).to eq(1)
      end

      it 'returns details of the attachement' do
        body = JSON.parse(response.body)
        file_obj = body['files'].first

        expect(file_obj['created_at']).to be
        expect(file_obj['filename']).to eq('test.txt')
        expect(file_obj['link']).to be
      end
    end
  end
end
