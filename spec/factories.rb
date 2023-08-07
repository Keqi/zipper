# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'maciej.nowak' }
    password { 'Abcde12345!!' }
  end
end
