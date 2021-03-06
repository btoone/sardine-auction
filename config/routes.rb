# frozen_string_literal: true

Rails.application.routes.draw do
  post '/registrations', to: 'registrations#create'
  get '/bids/current', to: 'bids#current'
  post '/bids', to: 'bids#create'
end
