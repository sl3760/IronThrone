class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :owner
      t.boolean :history
      t.boolean :whisper

      t.timestamps
    end
  end
end
