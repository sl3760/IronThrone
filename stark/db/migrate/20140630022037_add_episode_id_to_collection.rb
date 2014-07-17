class AddEpisodeIdToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :episode_id, :integer
  end
end
