# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bid, type: :model do
  describe '#highest' do
    before do
      FactoryBot.create :bid
    end

    it 'returns the current highest bid' do
      high_bid = FactoryBot.create :bid, amount: 1.5
      expect(Bid.highest).to eq high_bid
    end
  end
end
