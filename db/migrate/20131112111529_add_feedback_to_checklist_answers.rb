class AddFeedbackToChecklistAnswers < ActiveRecord::Migration
  def change
    add_column :checklist_answers, :feedback, :text
  end
end
