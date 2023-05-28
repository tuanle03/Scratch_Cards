class CreateGamePlayerCards < ActiveRecord::Migration[7.0]
  def change
    create_table :game_player_cards do |t|
      t.integer :game_player_id
      t.integer :card_id
      t.string :option

      t.timestamps
    end
  end
end
