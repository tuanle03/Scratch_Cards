class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.integer :bookmaker_id
      t.string :name
      t.string :code
      t.string :password
      t.integer :bets

      t.timestamps
    end
  end
end
