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

