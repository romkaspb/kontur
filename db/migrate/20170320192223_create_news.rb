class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
      t.string :title
      t.text :annotation
      t.datetime :publicated_until
      t.integer :owner, default: 0

      t.timestamps
    end

    add_index :news, :owner, unique: true
  end
end
