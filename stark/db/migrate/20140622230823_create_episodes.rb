class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :name
      t.text :script
      t.string :image_url
     # t.integer :good_num
     # t.integer :bad_num
     # t.integer :comment_num

      t.timestamps
    end
  end
end
