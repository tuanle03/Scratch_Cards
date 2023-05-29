class AddCurrentPlayersToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :current_players, :integer, default: 0
  end
end
