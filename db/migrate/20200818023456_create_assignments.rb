class CreateAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :assignments do |t|
      t.string :title
      t.date :due_date
      t.float :weighting
      t.integer :max_points
      t.timestamps
    end
  end
end
