# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Seeding in courses
require 'csv'

csv_text = File.read(Rails.root.join('lib','seeds','Course_Data.csv'))
csv = CSV.parse(csv_text, :headers => true)

# Course.delete_all

max = 300
cur = 0

course_id = []

csv.each do |row|
    if (cur >= max)
        break
    end
    course_id.push(row["Course_ID"])
    cur += 1
    c = Course.new
    c.course_id = row["Course_ID"]
    c.eff_date = row["Eff_Date"]
    c.short_title = row["Short_Title"]
    c.subject = row["Subject"]
    c.long_title = row["Long_Title"]
    c.descr = row["Descr"]
    c.save!
end

# Seeding in Assignments
csv_text = File.read(Rails.root.join('lib','seeds','Assignment_Data.csv'))
csv = CSV.parse(csv_text, :headers => true)
Assignment.delete_all
cur = 0

csv.each do |row|
    a = Assignment.new
    a.course_id = course_id[cur%max]
    cur += 1
    a.title = row["title"]
    a.due_date = row["due_date"]
    a.weighting = row["weighting"]
    a.max_points = row["points"]
    a.save!
end

# Seeding in Markers
csv_text = File.read(Rails.root.join('lib','seeds','Marker_Data.csv'))
csv = CSV.parse(csv_text, :headers => true)

csv.each do |row|
    m = Marker.new
    m.courses = Course.order('RANDOM()').first(3)
    m.uni_id = row["uni_id"]
    m.name = row["name"]
    m.email = row["email"]
    m.save!
end