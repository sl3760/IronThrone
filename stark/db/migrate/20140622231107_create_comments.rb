class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :episode_id
      t.text :content

      t.timestamps
    end
  end
end
