class AddAssignmentsToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :assignments, :course_id, :int
  end
end
