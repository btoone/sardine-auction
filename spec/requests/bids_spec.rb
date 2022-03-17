# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bids', type: :request do
  describe 'GET /bids/current' do
    before do
      headers = { 'Accept': 'application/json' }
    end

    it 'responds with status :ok' do
      get '/bids/current', headers: headers

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end

    context 'when multiple bids' do
      before do
        FactoryBot.create :bid
        FactoryBot.create :bid, amount: 1.25
      end

      it 'returns the current highest bid' do
        get '/bids/current', headers: headers

        expect(JSON.parse(response.body)).to eq highest_bid
      end
    end
  end

  def highest_bid
    JSON.parse(file_fixture('bid_not_authorized_highest.json').read)
  end
end
