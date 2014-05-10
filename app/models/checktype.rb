class Checktype < ActiveRecord::Base
  attr_accessible :name
  has_many :checks, class_name: 'ChecklistCheck', :foreign_key => "type_id"
  has_many :topics_checks, through: :checks

end
