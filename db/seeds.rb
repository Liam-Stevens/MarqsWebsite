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

# Seed in some web submissions
csv_text = File.read(Rails.root.join('lib', 'seeds', 'WebSubmission_Data_All.csv'))
csv = CSV.parse(csv_text, :headers => true)

csv.each do |row|
    # Skip over entries which aren't enrolled
    if (row["Course"] == "0000_Submission - No Enrolment")
        next
    end

    # Check if we have a 'Web Submission' assignment for the course
    # The regex here gets the last number in the course as the courses
    # have the format (xxxx_short_description_yyyy), where yyyy is the id
    course_id = row["Course"][/(\d+)\z/]
    assignment = Assignment.find_by(:course_id => course_id, :title => "Web Submission")

    # Create the 'Web Submission' assignment if there isn't one
    if (assignment == nil)
        assignment = Assignment.new
        assignment.course_id = course_id
        assignment.title = "Web Submission"
        assignment.due_date = "25/12/2020"
        assignment.weighting = 0;
        assignment.max_points = 0;
        assignment.save!
    end

    # Now that we have an assignment this submission belongs to, create the submission
    s = Submission.new
    s.assignment_id = assignment.id
    s.grade = row["Mark"]
    s.submitted_date = "1/1/2000"
    s.save!
end

# Seed in some submissions for random assignments
# (note that the random seed is set to hopefully get repeated behaviour)
srand(42)
assignments = Assignment.all
csv_text = File.read(Rails.root.join('lib', 'seeds', 'Submission_Data.csv'))
csv = CSV.parse(csv_text, :headers => true)

csv.each do |row|
    # Get a 'random' assignment
    idx = rand(assignments.count)
    assignment = assignments[idx]

    # Create submission and save
    s = Submission.new
    s.assignment_id = assignment.id
    s.grade = row["grade"]
    s.submitted_date = row["submitted_date"]
    s.save!
end