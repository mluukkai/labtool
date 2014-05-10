class AddOrderingToChecklistAnswers < ActiveRecord::Migration
  def change
    add_column :checklist_answers, :ordering, :integer
  end
end
