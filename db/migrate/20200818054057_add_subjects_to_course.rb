class AddSubjectsToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :subject, :string
  end
end
