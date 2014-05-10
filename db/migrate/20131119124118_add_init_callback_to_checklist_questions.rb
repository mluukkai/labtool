class AddInitCallbackToChecklistQuestions < ActiveRecord::Migration
  def change
    add_column :checklist_questions, :init_callback, :text
  end
end
