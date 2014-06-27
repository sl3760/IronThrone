class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.integer :episode_id
      t.integer :user_id

      t.timestamps
    end
  end
end
