class AddMarkedDateToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :marked_date, :date
  end
end
