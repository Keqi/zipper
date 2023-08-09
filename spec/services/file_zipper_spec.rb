# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileZipper, type: :service do
  describe '#zip' do
    before(:all) do
      input_file = fixture_file_upload('test.txt')

      @zipper = described_class.new(input_file:)
      @zipper.zip
      @zipper
    end

    it 'returns File object with zipped content' do
      expect(@zipper.file).to be_a(File)
      expect(@zipper.file.path).to end_with('.zip')
    end

    it 'generates unique password for the zip package' do
      expect(@zipper.password.length).to eq(30)
      expect(@zipper.password).to match(/[a-zA-z0-9]*/)
    end
  end
end
