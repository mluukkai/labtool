class Course < ActiveRecord::Base
  attr_accessible :period, :year, :review_round, :active, :week, :state, :mandatory_reviews, :name, :week_feedback_max_points, :email_instructor, :email_student, :weeks_total, :reviews_total

  has_many :registrations, :dependent => :destroy

  validates :period, :presence => true
  validates :year,  numericality: {only_integer: true, greater_than_or_equal_to: 1970, less_than_or_equal_to: 2100}
  validates :weeks_total,  numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 6}
  validates :reviews_total,  numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2}

  def review_registration
    return "open" if state == 1
    return "closed"
  end

  def registered_users
    #User.select { |s| s.registered_to self }.sort_by{ |s| s.surename.downcase }
    registrations.map{ |r| r.user }.uniq
  end

  def reviews_for_round number
    PeerReview.for self, number
  end

  def to_s
    "#{year}, #{period}"
  end

  def to_s
    name || "Ohjelmoinnin harjoitustyo"
  end

  def self.active
    Course.where( :active => true ).first
  end

end
