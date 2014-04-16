class AddCreatorToWeekFeedbacks < ActiveRecord::Migration
  def up
    add_column :week_feedbacks, :giver_id, :integer
  end

  def down
    remove_column :week_feedbacks, :giver_id
  end
end
