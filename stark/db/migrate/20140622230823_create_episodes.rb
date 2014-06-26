class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :name
      t.text :script
      t.string :image_url

      t.timestamps
    end
  end
end
