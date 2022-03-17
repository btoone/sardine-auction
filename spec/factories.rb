# frozen_string_literal: true

FactoryBot.define do
  factory :bid do
    amount { 0.01 }
    owner { false }
  end

  factory :registration do
    username { 'sardine_user' }
    address { '0xF3D713a2Aa684E97de770342E1D1A2e6D65812A7' }
  end
end
