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
end
