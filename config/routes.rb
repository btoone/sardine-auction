# frozen_string_literal: true

Rails.application.routes.draw do
  post '/registrations', to: 'registrations#create'
end
