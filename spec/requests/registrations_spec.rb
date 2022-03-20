# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  describe 'POST /registrations' do
    let(:registration_params) { FactoryBot.attributes_for :registration }
    let(:headers) do
      { 'Content-Type': 'application/json' }
    end

    it 'registers a user' do
      post '/registrations/', params: registration_params.to_json, headers: headers

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
      expect(Registration.last.username).to eq registration_params[:username]
    end

    it 'returns a secret key' do
      post '/registrations/', params: registration_params.to_json, headers: headers

      expect(JSON.parse(response.body)).to include('secret')
    end

    context 'with an invalid username' do
      # username has already been taken
      let(:registration_params) { FactoryBot.attributes_for :registration, username: Registration.first.username }

      before do
        FactoryBot.create :registration
      end

      it 'responds with a :unprocessable_entity' do
        post '/registrations/', params: registration_params.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
