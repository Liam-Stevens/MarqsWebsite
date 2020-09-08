Given('the following courses are in the database') do |table|
    # Create a course for each row
    table.hashes.each do |row|
        c = Course.new
        c.course_id = row[:course_id]
        c.eff_date = row[:eff_date]
        c.short_title = row[:short_title]
        c.long_title = row[:long_title]
        c.descr = row[:descr]
        c.subject = row[:subject]
        c.save!
    end
end

Given('the following assignments are in the database') do |table|
    # Create an assignment for each row
    table.hashes.each do |row|
        a = Assignment.new
        a.title = row[:title]
        a.due_date = row[:due_date]
        a.weighting = row[:weighting]
        a.max_points = row[:max_points]
        a.course_id = row[:course_id]
        a.save!
    end
end

Given('I press {string} for the course {string}') do |button, course|
    # Find course row in page
    elm = page.find("table tbody tr", text: course)

    # Press 'button'
    elm.click_link(button)
end