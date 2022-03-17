# frozen_string_literal: true

class Registration < ApplicationRecord
  validates :username, uniqueness: true
end
