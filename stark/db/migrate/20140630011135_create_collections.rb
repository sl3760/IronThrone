class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :user_id
      t.string :writer_name
      t.text :script
      t.string :image_url
      t.string :time

      t.timestamps
    end
  end
end
