class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.integer :good_num
      t.integer :bad_num
      t.integer :comment_num

      t.timestamps
    end
  end
end
