class CreateRegistration < ActiveRecord::Migration[6.0]
  def change
    create_table :registrations do |t|
      t.string :username
      t.string :address

      t.timestamps
    end
  end
end
