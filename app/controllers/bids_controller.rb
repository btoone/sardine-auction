# frozen_string_literal: true

class BidsController < ApplicationController
  def current
    render json: { 'highest_bid' => Bid.highest }, status: :ok
  end
end
