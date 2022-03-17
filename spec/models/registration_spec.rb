# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Registration, type: :model do
  describe 'A valid Registration' do
    it 'has a unique username' do
      original = FactoryBot.build :registration, username: 'user'
      duplicate = FactoryBot.build :registration, username: 'user'
      original.save

      expect(duplicate).not_to be_valid
    end
  end

  describe '#as_json' do
    let(:registration) { FactoryBot.create :registration }

    it 'does not include timestamps' do
      expect(registration.as_json).not_to include('id', 'created_at', 'updated_at')
    end

    it 'serializes the username and address' do
      expect(registration.as_json).to include(
        'username' => registration.username,
        'address' => registration.address
      )
    end
  end

  describe '#to_json' do
    let(:registration) { FactoryBot.create :registration }

    it 'returns a JSON string' do
      actual = registration.to_json
      expect(JSON.parse(actual)).to eq registration.as_json
    end
  end
end
