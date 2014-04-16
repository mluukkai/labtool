class CreateFeedbackComments < ActiveRecord::Migration
  def change
    create_table :feedback_comments do |t|
      t.text :text
      t.references :user
      t.references :week_feedback

      t.timestamps
    end
  end
end
