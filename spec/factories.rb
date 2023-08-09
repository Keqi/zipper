# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    password { Faker::Internet.password(min_length: 12, special_characters: true) }
  end
end
