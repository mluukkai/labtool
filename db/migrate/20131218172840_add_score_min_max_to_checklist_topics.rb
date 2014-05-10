class AddScoreMinMaxToChecklistTopics < ActiveRecord::Migration
  def change
    add_column :checklist_topics, :scale_max, :decimal
    add_column :checklist_topics, :scale_min, :decimal

  end
end
