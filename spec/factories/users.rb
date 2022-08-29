# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { "#{Time.now.to_i}.#{Faker::Internet.email}" }
    password { 'password' }
  end
end
