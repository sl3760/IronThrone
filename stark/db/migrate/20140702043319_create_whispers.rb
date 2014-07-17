class CreateWhispers < ActiveRecord::Migration
  def change
    create_table :whispers do |t|
      t.integer :guest
      t.integer :owner
      t.text :content

      t.timestamps
    end
  end
end
