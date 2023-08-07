# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  let!(:user) { create(:user, username: 'maciej.nowak', password: 'Abcde12345!!') }

  describe '#create' do
    context 'when authentication did not pass' do
      before { post sign_in_path, params: { username: 'maciej.nowak', password: '12345' } }

      it 'does not save the session user ID' do
        expect(session[:user_id]).to eq(nil)
      end

      it 'returns the error message with status 400' do
        body = JSON.parse(@response.body)

        expect(response.status).to eq(400)
        expect(body['errors']).to eq('The username/password combination is invalid.')
      end
    end

    context 'when authentication was successful' do
      before { post sign_in_path, params: { username: user.username, password: user.password } }

      it 'saves the session user ID' do
        expect(session[:user_id]).to eq(user.id)
      end

      it 'returns successful message with status 200' do
        body = JSON.parse(@response.body)

        expect(response.status).to eq(200)
        expect(body['message']).to eq('You have been successfully signed in.')
      end
    end
  end

  describe '#destroy' do
    context 'when user has been previously signed in' do
      before do
        as_signed_in_user(user:)
        post sign_out_path
      end

      it 'destroys the session user ID' do
        expect(session[:user_id]).to eq(nil)
      end

      it 'returns successful message with status 200' do
        body = JSON.parse(@response.body)

        expect(response.status).to eq(200)
        expect(body['message']).to eq('You have been successfully signed out.')
      end
    end

    context 'when user has not been signed in yet' do
      before { post sign_out_path }

      it 'returns error message with status 400' do
        body = JSON.parse(@response.body)

        expect(response.status).to eq(400)
        expect(body['errors']).to eq('You are already signed out.')
      end
    end
  end
end
