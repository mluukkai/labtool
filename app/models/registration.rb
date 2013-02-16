class Registration < ActiveRecord::Base
  attr_accessible :repository, :topic

  belongs_to :course
  belongs_to :user
  has_many :week_feedbacks

  def self.current
    Registration.all.select{|r| r.course.active }
  end

  def self.past
    Registration.all.reject{|r| r.course.active }
  end

  def review_targets_for round
    review_targets.select{ |p| p.round == round }
  end

  def review_targets
    PeerReview.select{ |p| p.reviewer_id == id}
  end

  def reviewers_for round
    reviewers.select{ |p| p.round == round }
  end

  def reviewers
    PeerReview.select{ |p| p.reviewed_id == id}
  end

  def feedback_given
    "#{feedback.map(&:week)}"[1..-2]
    (1..6).inject("") { |points, n|
      points += (points_for_week n)+" "
    }
  end

  def review_status
    r1 = review_targets_for 1
    r2 = review_targets_for 2
    ([ stringify(r1) ,  stringify(r2)]).join(" ")
  end

  def review_status_for_week week
    stringify(review_targets_for week)
  end

  def stringify r
    return "-" if  r.empty?
    return "todo" if not r.first.done
    "done"
  end

  def points_for_week week
    week_feedbacks.each{ |f|
      return f.points.to_s if f.week == week
    }
    return "-"
  end

  def feedback
    week_feedbacks.sort_by{ |f| f[:week] }
  end
end
