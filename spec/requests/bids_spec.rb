# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bids', type: :request do
  describe 'GET /bids/current' do
    it 'responds with status :ok' do
      get '/bids/current'

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end

    context 'when multiple bids' do
      before do
        FactoryBot.create :bid
        FactoryBot.create :bid, amount: 1.25
      end

      it 'returns the current highest bid' do
        get '/bids/current'

        expect(JSON.parse(response.body)).to eq bid_not_authorized_highest
      end
    end

    context 'when authorized' do
      let(:registration) { Registration.last }
      let(:headers) do
        { 'secret': registration.username }
      end

      before do
        FactoryBot.create :bid, amount: 1.25
      end

      it 'includes the user\'s latest bid' do
        get '/bids/current', headers: headers

        expect(JSON.parse(response.body)).to include 'current_bid' => { 'amount' => 1.25 }
      end

      it 'tells the user if the current highest bid is their own' do
        get '/bids/current', headers: headers

        expect(JSON.parse(response.body)).to eq bid_authorized_highest
      end
    end
  end

  describe 'POST /bids' do
    let(:bid_params) { FactoryBot.attributes_for :bid }
    let(:registration) { Registration.last }
    let(:headers) do
      {
        'Content-Type': 'application/json',
        'secret': registration.username
      }
    end

    before do
      FactoryBot.create :registration
    end

    it 'creates a new bid' do
      post '/bids', params: bid_params.to_json, headers: headers

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
      expect(Bid.last.amount).to eq bid_params[:amount]
    end

    context 'when not authorized' do
      it 'responds with unauthorized' do
        post '/bids', params: bid_params.to_json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  def bid_not_authorized_highest
    JSON.parse(file_fixture('bid_not_authorized_highest.json').read)
  end

  def bid_authorized_highest
    JSON.parse(file_fixture('bid_authorized_highest.json').read)
  end
end
