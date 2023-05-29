class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.integer :point
      t.string :name
      t.string :suit

      t.timestamps
    end
  end
end
