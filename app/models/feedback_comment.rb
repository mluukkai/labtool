class FeedbackComment < ActiveRecord::Base
  attr_accessible :points, :text, :week, :hidden_text
  belongs_to :week_feedback
  belongs_to :user

end
