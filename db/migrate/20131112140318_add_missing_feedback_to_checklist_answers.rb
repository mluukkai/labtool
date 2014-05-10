class AddMissingFeedbackToChecklistAnswers < ActiveRecord::Migration
  def change
    add_column :checklist_answers, :missing_feedback, :text
  end
end
