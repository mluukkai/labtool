class CreateChecklistRegistrationAnswers < ActiveRecord::Migration
  def change
    create_table :selected_answers do |t|
      t.references :checklist_answer
      t.references :registration
      t.boolean :selected

      t.timestamps
    end
  end
end
