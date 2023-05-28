class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :room_id
      t.integer :bookmaker_id
      t.integer :current_bets
      t.string :status

      t.timestamps
    end
  end
end
