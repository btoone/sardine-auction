# frozen_string_literal: true

FactoryBot.define do
  factory :bid do
    amount { 0.01 }
    owner { false }
    association :registration
  end

  factory :registration do
    sequence(:username) { |n| "user#{n}" }
    address { '0xABC123' }
  end
end
