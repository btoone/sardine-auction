# frozen_string_literal: true

class Bid < ApplicationRecord
  belongs_to :registration

  validates :amount, numericality: { greater_than: 0.0 }
  validate :amount_must_be_greater

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

  def amount_must_be_greater
    bids = Bid.pluck(:amount)

    return if bids.empty?

    errors.add(:amount, 'Amount must be greater than previous bid') if amount <= bids.max
  end
end
