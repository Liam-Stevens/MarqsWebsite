class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students,:primary_key => 'student_id' do |t|
      t.string :first_name
      t.string :last_name
      t.timestamps
    end
  end

  ActiveRecord::Base.connection.execute("UPDATE SQLITE_SEQUENCE SET seq = 1740000 WHERE name = 'id'")
end
