# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  let!(:user) { create(:user, username: 'maciej.nowak', password: 'Abcde12345!!') }

  describe '#create' do
    context 'when authentication did not pass' do
      before { post sign_in_path, params: { username: 'maciej.nowak', password: '12345' } }

      it 'returns the error message with status 400' do
        body = JSON.parse(@response.body)

        expect(response.status).to eq(400)
        expect(body['errors']).to eq('The username/password combination is invalid.')
      end
    end

    context 'when authentication was successful' do
      before { post sign_in_path, params: { username: user.username, password: user.password } }

      it 'returns successful message with status 200 and token' do
        body = JSON.parse(@response.body)

        expect(response.status).to eq(200)
        expect(body['token']).to_not eq(nil)
      end
    end
  end
end
