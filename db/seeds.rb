# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Seeding in courses
require 'csv'

csv_text = File.read(Rails.root.join('lib','seeds','CM_CRSE_CAT_ECMS-6383074.csv'))
csv = CSV.parse(csv_text, :headers => true)

csv.each do |row|
    c = Course.new
    c.course_id = row["Course_ID"]
    c.eff_date = row["Eff_Date"]
    c.short_title = row["Short_Title"]
    c.long_title = row["Long_Title"]
    c.descr = row["Descr"]
    c.save
end

