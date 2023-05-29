class AddPlayersToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :players, :integer
  end
end
