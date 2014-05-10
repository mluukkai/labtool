class AddValuesToChecklistTopicsChecks < ActiveRecord::Migration
  def change
    add_column :checklist_topics_checks, :value, :decimal, :default => 0, :null => false
    add_column :checklist_topics_checks, :unchecked_value, :decimal, :default => 0, :null => false

    execute 'update checklist_topics_checks set 
      value = weight_factor*(select value from checklist_checks c where c.id = checklist_check_id);'
    execute 'update checklist_topics_checks set 
      unchecked_value = weight_factor*(select unchecked_value from checklist_checks c where c.id = checklist_check_id);'

    remove_column :checklist_topics_checks, :weight_factor
  end
end
