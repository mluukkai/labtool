class CreateChecktype < ActiveRecord::Migration
  def change
    create_table :checktypes do |t|
      t.string :name, :null => false
    end

    add_column :checklist_checks, :type_id, :integer
  end
end
