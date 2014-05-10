class FixTypo < ActiveRecord::Migration
  def change
    rename_column :checklist_topics, :scale_demoninator, :scale_denominator
  end
end
