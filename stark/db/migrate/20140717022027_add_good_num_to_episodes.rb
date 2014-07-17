class AddGoodNumToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :good_num, :integer
  end
end
