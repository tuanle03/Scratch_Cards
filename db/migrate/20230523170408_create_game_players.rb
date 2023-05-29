class CreateGamePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :game_players do |t|
      t.integer :game_id
      t.integer :player_id
      t.string :status

      t.timestamps
    end
  end
end
