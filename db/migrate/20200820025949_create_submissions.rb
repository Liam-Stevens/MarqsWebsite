class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.belongs_to :assignment
      t.integer :grade
      t.date :submitted_date
      t.text :feedback
      t.timestamps
    end
  end
end
