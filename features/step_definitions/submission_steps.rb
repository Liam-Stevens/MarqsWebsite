Given('the following submissions are in the database') do |table|
    # Create an submission for each row
    table.hashes.each do |row|
        s = Submission.new
        s.assignment_id = row[:assignment_id]
        s.grade = row[:grade]
        s.submitted_date = row[:submitted_date]
        s.student_id = row[:student_id]
        s.save!
    end
end

Then('I should see a submission for {string}') do |student_id|
    # Find submission row in page
    elm = page.find("table tbody tr", text: student_id)
end