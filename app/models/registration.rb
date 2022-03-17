# frozen_string_literal: true

class Registration < ApplicationRecord
  validates :username, uniqueness: true

  # Returns a hash, that can be serialized into a JSON string
  def as_json(options = {})
    {
      'username' => username,
      'address' => address
    }
  end

  # Stores as a json string
  def to_json(*options)
    as_json(*options).to_json(*options)
  end
end
