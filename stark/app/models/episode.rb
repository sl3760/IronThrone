class Episode < ActiveRecord::Base
  has_many :comments

  validates :name, presence: true, length: { maximum: 20 }
  validates :script, presence: true, length: { maximum: 500 }

  validates :good_num, presence: true
  validates :bad_num, presence: true
  validates :comment_num, presence: true
end
