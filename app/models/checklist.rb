class Checklist < ActiveRecord::Base
  attr_accessible :title, :ordering, :init_callback, :grade_callback, :remarks
  has_many :topics, class_name: 'ChecklistTopic', dependent: :destroy, autosave: true
  has_many :topics_checks,    through: :topics
  has_many :checks,    through: :topics_checks
  has_many :passed_checks, through: :checks
  has_many :scoretypes, through: :topics, :uniq => true, :order => 'name'
end
