class AddDefaultChecklistToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :default_checklist_id, :integer
  end
end
