# frozen_string_literal: true

class BidsController < ApplicationController

  before_action :set_registration
  before_action :validate_params, only: :create

  def current
    highest_bid = Bid.highest

    if authorized?
      response = {
        'current_bid': { 'amount': @registration.current_bid.amount },
        'highest_bid' => { 'amount': highest_bid.amount, 'owner': highest_bid.registration == @registration }
      }
      render json: response, status: :ok
    else
      render json: { 'highest_bid' => { 'amount': highest_bid.amount, 'owner': highest_bid.registration == @registration } }, status: :ok
    end
  end

  def create
    if authorized?
      bid = Bid.new(bid_params)
      bid.registration = @registration
      if bid.save
        render json: bid.to_json, status: :created
      else
        render json: { error: bid.errors.full_messages }, status: :unprocessable_entity
      end
    else
      head :unauthorized
    end
  end

  private

  def authorized?
    @registration.present?
  end

  def set_registration
    secret = request.headers[:HTTP_SECRET]
    @registration = Registration.find_by(username: SecretService.new.decode_secret(secret)) unless secret.nil?
  end

  def validate_params
    return if Bid.all.empty?

    message = 'You already have the current highest bid'
    render json: { error: message }, status: :unprocessable_entity if @registration.id == Bid.last.registration_id
  end

  def bid_params
    params.require(:bid).permit(:amount)
  end
end
