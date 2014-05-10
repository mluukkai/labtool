class AddUncheckedValueToChecklistAnswers < ActiveRecord::Migration
  def change
    add_column :checklist_answers, :unchecked_value, :decimal
  end
end
