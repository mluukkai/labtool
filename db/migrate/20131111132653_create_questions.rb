class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :checklist_questions do |t|
      t.text :question
      t.string :varname
      t.integer :ordering
      t.references :checklist
      t.references :scoretype
      t.text :update_callback
    end
  end
end
