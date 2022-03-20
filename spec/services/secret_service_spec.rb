# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SecretService, type: :service do

  describe 'GET /bids/current' do
    describe '#generate_secret' do
      let(:service) { SecretService.new }

      it 'encrpyts data' do
        actual = service.generate_secret('hello')
        expect(service.decode_secret(actual)).to eq 'hello'
      end
    end

    describe '#decode_secret' do
      let(:service) { SecretService.new }

      it 'decrypts data' do
        secret_msg = service.generate_secret('hello world')

        actual = service.decode_secret(secret_msg)
        expect(actual).to eq 'hello world'
      end

      context 'when new instance of MessageEncryptor' do
        # create a new instance
        let(:new_instance_of_service) { SecretService.new }

        it 'decrpyts data' do
          # encrypt with the first instance of MessageEncryptor
          secret = service.generate_secret('hello world')

          # use data from the first instance; decrypt using the new instance of ME
          actual = new_instance_of_service.decode_secret(secret)
          expect(actual).to eq 'hello world'
        end
      end
    end
  end
end
