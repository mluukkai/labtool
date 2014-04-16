class WeekFeedback < ActiveRecord::Base
  attr_accessible :points, :text, :week, :hidden_text
  belongs_to :registration
  belongs_to :giver, class_name: 'User'
  has_many :feedback_comments

  validates :week, :numericality => {:greater_than_or_equal_to => 1}
  validates :points, :numericality => {:greater_than_or_equal_to => 0}
  validate :points_within_range


  def max
    return 3 if Course.active.nil?
    Course.active.week_feedback_max_points || 3
  end

  def user
    registration.user
  end

  def points_within_range
    errors.add(:points, "should be at most #{max}") if points.nil? or points>max
  end

end
