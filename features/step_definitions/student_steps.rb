Given('the following students are in the database') do |table|
    # Create a student for each row
    table.hashes.each do |row|
        s = Student.new
        s.student_id = row[:student_id]
        s.first_name = row[:first_name]
        s.last_name = row[:last_name]
        s.save!
    end
end

Given('the following students are assigned to the courses') do |table|
    # Iterate over each row and assign student to courses
    table.hashes.each do |row|
        # Split courses to get IDs
        ids = row[:courses].split(%r{,\s*})

        # Assign courses
        s = Student.find(row[:student_id])
        ids.each do |id|
            s.courses << Course.find(id)
        end
        s.save!
    end
end