# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def create
    registration = Registration.new(registration_params)

    if registration.save
      render json: { secret: '1234asdf' }, status: :created
    else
      render json: { message: registration.errors.full_messages }, status: 422
    end
  end

  private

  def registration_params
    params.permit(:username, :address)
  end
end
