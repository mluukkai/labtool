class CreateScoretypes < ActiveRecord::Migration
  def change
    create_table :scoretypes do |t|
      t.string :name, null: false
      t.string :varname
      t.decimal :initial, default: 0, null: false
      t.decimal :min, default: 0, null: false
      t.decimal :max, default: 3, null: false
    end
  end
end
