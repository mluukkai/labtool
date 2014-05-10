class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.string :title
      t.integer :ordering
      t.integer :parent_id
      t.text :init_callback
      t.text :grade_callback
    end
  end
end
