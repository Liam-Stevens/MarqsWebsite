Given 'the database is seeded' do
    # Add some courses
    courses = [[1001, "20/08/2020", "Test Course", "Test Course", "A test course", "TESTSUB"],
               [1002, "19/08/2020", "Reading", "Reading Intro", "Learn to read", "ENG PRI"],
               [1069, "21/10/2020", "Hidden Boi", "Hidden Boi", "Can't be seen", "HIDDEN"]]
    courses.each do |course|
        c = Course.new
        c.course_id = course[0]
        c.eff_date = course[1]
        c.short_title = course[2]
        c.long_title = course[3]
        c.descr = course[4]
        c.subject = course[5]
        c.save!
    end

    # Add some markers
    markers = [[1700001, "Mark", "Marker"],
               [1700002, "John", "Johnson"]]
    markers.each do |marker|
        m = Marker.new
        m.marker_id = marker[0]
        m.first_name = marker[1]
        m.last_name = marker[2]
        m.save!
    end

    # Assign markers to courses
    pairs = [[1700001, [1001, 1002]]]
    pairs.each do |pair|
        m = Marker.find(pair[0])
        pair[1].each do |course|
            m.courses << Course.find(course)
        end
        m.save!
    end

    # Add some students
    students = [[1740001, "Amelia", "Adams"],
                [1740420, "Bill", "Gates"],
                [1740021, "Bugs", "Bunny"]]
    students.each do |student|
        s = Student.new
        s.student_id = student[0]
        s.first_name = student[1]
        s.last_name = student[2]
        s.save!
    end

    # Assign students to courses
    pairs = [[1740001, [1001, 1002]], [1740021, [1069]]]
    pairs.each do |pair|
        s = Student.find(pair[0])
        pair[1].each do |course|
            s.courses << Course.find(course)
        end
        s.save!
    end

    # Add some assignments
    assignments = [["Test Assignment 1", "3/09/2020", 0.2, 100, 1001],
                   ["Test Assignment 2", "10/09/2020", 0.8, 200, 1001],
                   ["Read Book 1", "1/1/2000", 0.5, 50, 1069]]
    assignments.each do |assignment|
        a = Assignment.new
        a.title = assignment[0]
        a.due_date = assignment[1]
        a.weighting = assignment[2]
        a.max_points = assignment[3]
        a.course_id = assignment[4]
        a.save!
    end

    # Add some submissions
    submissions = [[1, 81.2, "1/09/2020", 4.days.ago, 1740001],
                   [1, 72, "11/03/2000", 1.month.ago, 1740420],
                   [2, 33, "8/09/2020", 9.days.ago, 1740021],
                   [3, 50, "2/1/2000", 9.days.ago, 1740021],
                   [1, nil, nil, nil, 1740021],
                   [2, nil, nil, nil, 1740001],
                   [2, nil, nil, nil, 1740420],
                   [3, nil, nil, nil, 1740001],
                   [3, nil, nil, nil, 1740420]]
    submissions.each do |submission|
        s = Submission.new
        s.assignment_id = submission[0]
        s.grade = submission[1]
        s.submitted_date = submission[2]
        s.marked_date = submission[3]
        s.student_id = submission[4]
        s.save!
    end

    # Finally add some comments
    comments = [[1, 1700001, "This is a comment"],
                [1, 1700002, "Another sentence of words"]]
    comments.each do |comment|
        c = Comment.new
        c.submission_id = comment[0]
        c.marker_id = comment[1]
        c.content = comment[2]
        c.save!
    end
end