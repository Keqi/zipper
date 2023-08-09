# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe '#create' do
    context 'when user params do not pass validations' do
      context 'when username is not present' do
        let(:params) { { username: nil, password: Faker::Internet.password(min_length: 12, special_characters: true) } }

        before { post users_path, params: }

        it 'does not create user record' do
          expect(User.count).to eq(0)
        end

        it 'returns bad request status with error messages' do
          body = JSON.parse(@response.body)

          expect(@response.status).to eq(400)
          expect(body['errors']).to include("Username can't be blank")
        end
      end

      context 'when username is not unique' do
        let(:params) do
          { username:, password: Faker::Internet.password(min_length: 12, special_characters: true) }
        end
        let(:username) { Faker::Internet.username }

        before do
          create(:user, username:,
                        password: Faker::Internet.password(min_length: 12, special_characters: true))
          post users_path, params:
        end

        it 'does not create user record' do
          expect(User.count).to eq(1)
        end

        it 'returns bad request status with error messages' do
          body = JSON.parse(@response.body)

          expect(@response.status).to eq(400)
          expect(body['errors']).to include('Username has already been taken')
        end
      end

      context 'when password is too short or doesnt match required format' do
        let(:params) do
          {
            username: Faker::Internet.username,
            password: Faker::Internet.password(min_length: 6, max_length: 6, mix_case: false)
          }
        end

        before { post users_path, params: }

        it 'does not create user record' do
          expect(User.count).to eq(0)
        end

        it 'returns bad request status with error messages' do
          body = JSON.parse(@response.body)

          too_short_msg = 'Password is too short (minimum is 12 characters)'
          format_msg = 'Password must include: 1 uppercase, 1 lowercase and 1 digit'

          expect(@response.status).to eq(400)
          expect(body['errors']).to include(too_short_msg)
          expect(body['errors']).to include(format_msg)
        end
      end
    end

    context 'when user params pass validations' do
      let(:params) do
        {
          username: Faker::Internet.username,
          password: Faker::Internet.password(min_length: 12, special_characters: true)
        }
      end

      before { post users_path, params: }

      it 'creates new user record' do
        expect(User.count).to eq(1)
      end

      it 'returns :created status with token' do
        body = JSON.parse(@response.body)

        expect(@response.status).to eq(201)
        expect(body['token']).to_not eq(nil)
      end
    end
  end
end