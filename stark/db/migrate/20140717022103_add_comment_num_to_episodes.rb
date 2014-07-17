class AddCommentNumToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :comment_num, :integer
  end
end
