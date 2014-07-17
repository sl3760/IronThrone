class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :active_id
      t.integer :passive_id

      t.timestamps
    end
  end
end
