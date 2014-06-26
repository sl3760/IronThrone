class Episode < ActiveRecord::Base
  has_many :comments

  validates :name, presence: true, length: { maximum: 20 }
  validates :script, presence: true, length: { maximum: 500 }
end
