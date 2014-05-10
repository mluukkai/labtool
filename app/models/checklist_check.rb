class ChecklistCheck < ActiveRecord::Base
  attr_accessible :check, :varname, :value, :unchecked_value, :feedback, :missing_feedback
  belongs_to :checktype, :foreign_key => "type_id"
  has_many :topics_checks, class_name: 'ChecklistTopicsCheck', dependent: :destroy, autosave: true
  has_many :topics, class_name: 'ChecklistTopic', through: :topics_checks
  has_many :passed_checks
  #default_scope :order => "checklist_checks.ordering"

  def type
    return nil if checktype.nil?
    checktype.name 
  end
  def type=
    return nil if checktype.nil?
    checktype.name 
  end

  def checked?(registration = nil) 
    return false if registration.nil?

    selected = passed_checks.find_by_registration_id registration
    
    return false if selected.nil?
    selected.selected
  end

  def has_valid_varname?
    return false if varname.nil?
    return false unless varname.match(/^[^\W\d]\w+$/)
    return false if varname.in? %w(topics checklist undefined null true false break class enum export extends import super implements interface let package private protected public static yield case catch continue debugger default delete do else finally for function if in instanceof new return switch this throw try typeof var void while with)
    true
  end
end
