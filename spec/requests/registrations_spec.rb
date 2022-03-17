# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  describe 'POST /registrations' do
    let(:registration_params) { FactoryBot.attributes_for :registration }

    before do
      headers = { 'Content-Type': 'application/json' }
      post '/registrations/', params: registration_params.to_json, headers: headers
    end

    it 'registers a user' do
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
      expect(Registration.last.username).to eq registration_params[:username]
    end

    it 'returns a secret key' do
      expect(JSON.parse(response.body)).to include('secret')
    end

    context 'with an invalid username' do
      it 'responds with a 422' do
        headers = { 'Content-Type': 'application/json' }
        post '/registrations/', params: registration_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
