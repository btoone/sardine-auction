# frozen_string_literal: true

class Bid < ApplicationRecord
  belongs_to :registration

  class << self
    def highest
      Bid.last
    end
  end

  # Returns a hash, that can be serialized into a JSON string
  def as_json(options = {})
    {
      'amount' => amount,
      'owner' => owner
    }
  end

  # Stores as a json string
  def to_json(*options)
    as_json(*options).to_json(*options)
  end
end
