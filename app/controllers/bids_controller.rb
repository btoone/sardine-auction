# frozen_string_literal: true

class BidsController < ApplicationController
  def current
    render json: { 'highest_bid' => Bid.highest }, status: :ok
  end

  def create
    if authorized?
    else
      head :unauthorized
    end
  end

  private

  def authorized?
    false
  end
end
