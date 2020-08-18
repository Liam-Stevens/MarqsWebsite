class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses,:primary_key => 'course_id' do |t|
      t.date :eff_date
      t.string :short_title
      t.string :long_title
      t.text :descr
    end
  end
end
