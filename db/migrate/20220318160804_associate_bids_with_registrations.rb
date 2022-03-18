class AssociateBidsWithRegistrations < ActiveRecord::Migration[6.0]
  def change
    add_reference :bids, :registration, foreign_key: true
  end
end
