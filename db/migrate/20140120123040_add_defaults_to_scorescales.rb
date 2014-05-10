class AddDefaultsToScorescales < ActiveRecord::Migration
  def up
    execute 'update checklist_topics set scale_numerator = 1 where scale_numerator is null'
    execute 'update checklist_topics set scale_denominator = 1 where scale_denominator is null'
    change_column :checklist_topics, :scale_denominator, :integer, :default => 1, :null => false
    change_column :checklist_topics, :scale_numerator, :integer, :default => 1, :null => false
  end
  def down
    change_column :checklist_topics, :scale_denominator, :integer, :default => nil, :null => true
    change_column :checklist_topics, :scale_numerator, :integer, :default => nil, :null => true
  end
end
