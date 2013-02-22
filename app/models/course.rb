class Course < ActiveRecord::Base
  attr_accessible :period, :year, :review_round, :active, :week, :state

  has_many :registrations, :dependent => :destroy

  validates :period, :presence => true
  validates :year,  numericality: {only_integer: true, greater_than_or_equal_to: 1970, less_than_or_equal_to: 2100}

  def review_registration
    return "open" if state == 1
    return "closed"
  end

  def reviews_for_round number
    PeerReview.for self, number
  end

  def to_s
    "#{year}, #{period}"
  end

  def self.active
    Course.where( :active => true ).first
  end
end
