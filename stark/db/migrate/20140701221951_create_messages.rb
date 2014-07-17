class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :owner
      t.integer :guest
      t.text :content
      t.boolean :public

      t.timestamps
    end
  end
end
