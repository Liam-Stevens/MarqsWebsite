class CreateCourseMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :course_members, id: false do |t|
      t.string :role
      t.references :marker, foreign_key: true
      t.references :course_id, references: :courses, null: false

      t.timestamps
    end

      # rename_column :course_members, :uni_id_id, :uni_id
      # add_foreign_key :course_members, :markers, column: 'uni_id', primary_key: 'uni_id'

      rename_column :course_members, :course_id_id, :course_id
      add_foreign_key :course_members, :courses, column: 'course_id', primary_key: 'course_id'
  end
end
