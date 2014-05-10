class RefactorChecklistTableNames < ActiveRecord::Migration
  def change
    rename_column :selected_answers, :checklist_answer_id, :checklist_check_id
    rename_column :checklist_answers, :checklist_question_id, :checklist_topic_id
    rename_column :checklist_answers, :answer, :check
    rename_column :checklist_questions, :question, :title

    rename_table :selected_answers, :passed_checks
    rename_table :checklist_answers, :checklist_checks
    rename_table :checklist_questions, :checklist_topics
  end
end
