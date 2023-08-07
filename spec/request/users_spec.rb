require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe '#create' do
    context 'when user params do not pass validations' do
      context 'when username is not present' do
        let(:params) { { username: nil, password: 'Abcde12345!!' } }

        before { post users_path, params: params }

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
        let(:params) { { username: 'maciej.nowak', password: 'Abcde12345!!' } }

        before do
          create(:user, username: 'maciej.nowak', password: 'Abcde12345!!')
          post users_path, params: params
        end

        it 'does not create user record' do
          expect(User.count).to eq(1)
        end

        it 'returns bad request status with error messages' do
          body = JSON.parse(@response.body)

          expect(@response.status).to eq(400)
          expect(body['errors']).to include("Username has already been taken")
        end
      end

      context 'when password is too short or doesnt match required format' do
        let(:params) { { username: 'maciej.nowak', password: '123' } }

        before { post users_path, params: params }

        it 'does not create user record' do
          expect(User.count).to eq(0)
        end

        it 'returns bad request status with error messages' do
          body = JSON.parse(@response.body)

          expect(@response.status).to eq(400)
          expect(body['errors']).to include("Password is too short (minimum is 12 characters)")
          expect(body['errors']).to include("Password must include: 1 uppercase, 1 lowercase, 1 digit and 1 special character")
        end
      end
    end

    context 'when user params pass validations' do
      let(:params) { { username: 'maciej.nowak', password: 'Abcde12345!!' } }

      before { post users_path, params: params }

      it 'creates new user record' do
        expect(User.count).to eq(1)
      end

      it 'returns :created status with short message' do
        body = JSON.parse(@response.body)

        expect(@response.status).to eq(201)
        expect(body['message']).to include("User created.")
      end
    end
  end
end