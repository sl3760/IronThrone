class AddBadNumToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :bad_num, :integer
  end
end
