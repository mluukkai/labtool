class AddRemarksToChecklists < ActiveRecord::Migration
  def change
    add_column :checklists, :remarks, :text
  end
end
