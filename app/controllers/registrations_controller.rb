# frozen_string_literal: true

class RegistrationsController < ApplicationController

  def create
    registration = Registration.new(registration_params)

    if registration.save
      secret = SecretService.new.generate_secret(registration.username)
      render json: { secret: secret }, status: :created
    else
      render json: { message: registration.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:username, :address)
  end
end
