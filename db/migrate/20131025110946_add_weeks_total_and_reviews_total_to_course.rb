class AddWeeksTotalAndReviewsTotalToCourse < ActiveRecord::Migration
  def up
    add_column :courses, :weeks_total, :integer
    add_column :courses, :reviews_total, :integer
  end

  def down
    remove_column :courses, :weeks_total
    remove_column :courses, :reviews_total
  end
end
