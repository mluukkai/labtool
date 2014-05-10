class CreateChecklistAnswers < ActiveRecord::Migration
  def change
    create_table :checklist_answers do |t|
      t.text :answer
      t.string :varname
      t.decimal :value
      t.references :checklist_question
    end
  end
end
