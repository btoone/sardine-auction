# frozen_string_literal: true

class BidsController < ApplicationController
  before_action :set_registration

  def current
    if authorized?
      highest_bid = Bid.highest
      response = {
        'current_bid': { 'amount': @registration.current_bid.amount },
        'highest_bid' => { 'amount': highest_bid.amount, 'owner': highest_bid.registration == @registration }
      }
      render json: response, status: :ok
    else
      render json: { 'highest_bid' => Bid.highest }, status: :ok
    end
  end

  def create
    if authorized?
    else
      head :unauthorized
    end
  end

  private

  def authorized?
    @registration.present?
  end

  def set_registration
    decoded_token = request.headers[:HTTP_SECRET]
    @registration = Registration.find_by(username: decoded_token)
  end
end
