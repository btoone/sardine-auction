# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bids', type: :request do

  describe 'GET /bids/current' do
    before do
      FactoryBot.create :bid
    end

    it 'responds with status :ok' do
      get '/bids/current'

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
    end

    context 'when multiple bids' do
      before do
        FactoryBot.create :bid, amount: 1.25
      end

      it 'returns the current highest bid' do
        get '/bids/current'

        expect(JSON.parse(response.body)).to eq bid_not_authorized_highest
      end
    end

    context 'when authorized' do
      let(:registration) { Registration.last }
      let(:service) { SecretService.new }
      let(:headers) do
        { 'secret': service.generate_secret(registration.username) }
      end

      before do
        FactoryBot.create :bid, amount: 1.25
      end

      it 'includes the user\'s latest bid' do
        get '/bids/current', headers: { 'secret': service.generate_secret(registration.username) }

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
    let(:service) { SecretService.new }
    let(:headers) do
      {
        'Content-Type': 'application/json',
        'secret': service.generate_secret(registration.username)
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

    context 'with consecutive bids from two different users' do
      let(:registration) { Registration.first }

      before do
        FactoryBot.create :bid
      end

      context 'when amounts are the same' do
        it 'responds with :unprocessable_entity' do
          post '/bids', params: bid_params.to_json, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'matches an error message /previous bid/' do
          post '/bids', params: bid_params.to_json, headers: headers
          actual = JSON.parse(response.body)
          expect(actual['error'].first).to match /previous bid/
        end
      end
    end

    context 'with consecutive bids from the same user' do
      before do
        FactoryBot.create :bid, registration: registration
      end

      it 'responds with :unprocessable_entity' do
        post '/bids', params: FactoryBot.attributes_for(:bid, amount: 0.5).to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'matches an error message /already have current highest bid/' do
        post '/bids', params: FactoryBot.attributes_for(:bid, amount: 0.5).to_json, headers: headers
        actual = JSON.parse(response.body)
        expect(actual['error']).to match /highest bid/
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
