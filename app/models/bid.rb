# frozen_string_literal: true

class Bid < ApplicationRecord
  class << self
    def highest
      Bid.last
    end
  end
end
