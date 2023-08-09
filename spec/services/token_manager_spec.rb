# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TokenManager, type: :service do
  describe 'encoding and decoding' do
    let(:payload) { { user_id: 123 } }

    subject(:token) { described_class.encode(payload:) }

    it 'generates the JWT token' do
      expect(token).to start_with('ey')
      expect(token.length).to be > 20
    end

    it 'encodes payload' do
      decoded_token = described_class.decode(token:).first
      expect(decoded_token['user_id']).to eq(123)
    end

    it 'encodes default expiration time in the payload' do
      decoded_token = described_class.decode(token:).first
      expiration_time = Time.at(decoded_token['exp'])
      time_range = (1.minute.ago..4.hours.from_now)

      expect(time_range).to cover(expiration_time)
    end
  end
end
