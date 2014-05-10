class FinallyDoThisScalingTopicsShit < ActiveRecord::Migration
  def change
    remove_column :checklist_topics, :scale_min
    remove_column :checklist_topics, :scale_max

    add_column :checklist_topics, :score_target, :decimal
    add_column :checklist_topics, :scale_demoninator, :integer
    add_column :checklist_topics, :scale_numerator, :integer
  end
end
