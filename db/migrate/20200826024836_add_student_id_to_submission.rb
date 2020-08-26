class AddStudentIdToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submission, :student_id, :integer
  end
end
