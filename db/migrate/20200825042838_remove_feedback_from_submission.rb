class RemoveFeedbackFromSubmission < ActiveRecord::Migration[5.2]
  def change
    remove_column :submissions, :feedback, :text
  end
end
