# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bid, type: :model do
  describe 'A valid Bid' do
    it 'is a number' do
      expect { FactoryBot.create :bid, amount: '' }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'is positive' do
      expect { FactoryBot.create :bid, amount: -1.0 }.to raise_error ActiveRecord::RecordInvalid
    end

    it 'must be greater than the previous bid' do
      bid = FactoryBot.create :bid, amount: 1.0
      expect { FactoryBot.create :bid, amount: 1.0, registration: bid.registration }.to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe '#highest' do
    before do
      FactoryBot.create :bid
    end

    it 'returns the current highest bid' do
      high_bid = FactoryBot.create :bid, amount: 1.5
      expect(Bid.highest).to eq high_bid
    end
  end

  describe '#as_json' do
    let(:bid) { FactoryBot.create :bid }

    it 'does not include timestamps' do
      expect(bid.as_json).not_to include('id', 'created_at', 'updated_at')
    end

    it 'serializes the amount and owner' do
      expect(bid.as_json).to include(
        'amount' => bid.amount,
        'owner' => bid.owner
      )
    end
  end

  describe '#to_json' do
    let(:bid) { FactoryBot.create :bid }

    it 'returns a JSON string' do
      actual = bid.to_json
      expect(JSON.parse(actual)).to eq bid.as_json
    end
  end
end
