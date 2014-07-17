class Statistic < ActiveRecord::Base
    validates :good_num, presence: true
    validates :bad_num, presence: true
    validates :comment_num, presence: true
end