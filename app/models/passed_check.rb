class PassedCheck < ActiveRecord::Base
  attr_accessible :selected
  belongs_to :checklist_check
  belongs_to :registration
end
