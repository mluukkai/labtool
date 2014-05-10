class CreateTableChecklistTopicChecks < ActiveRecord::Migration
  def change
    create_table :checklist_topics_checks do |t|
      t.references :checklist_topic
      t.references :checklist_check

      t.integer :ordering
      t.decimal :weight_factor, :default  => 1, :null => false
    end

  end
end
