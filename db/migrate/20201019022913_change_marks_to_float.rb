class ChangeMarksToFloat < ActiveRecord::Migration[5.2]
  def change
    remove_column :submissions, :grade
    add_column :submissions, :grade, :float
  end
end
