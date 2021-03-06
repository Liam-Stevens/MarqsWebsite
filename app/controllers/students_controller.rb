class StudentsController < ApplicationController
    add_breadcrumb "Dashboard", :student_path
    before_action :show_session_redirect

    def show
        # Pass list of courses
        @courses = @logged_in_user.courses

        @all_grade = []
        @grade_value = []

        student = Student.find(session[:id])

        # Calculating students grade for each course
        @courses.each do |course|
            @assignments = course.assignments

            @grades = []
            @max_grades = []
            @weightings = []

            @assignments.each do |assignment|
                grades_and_weighting_helper(assignment,student)
            end

            calculate_grades()
            @grade_value.append(get_letter_grade(@current_grade))
            @all_grade.append(@current_grade)
        end

        # Fetch a list of recently marked assignments (which are really submissions)
        @recently_marked = Submission.where(student_id: @logged_in_user.id, marked_date: 7.days.ago.beginning_of_day..Date.today)
        @recently_marked_grades = []
        @recently_marked.each do |submission|
            @recently_marked_grades.push(format_grade(submission.grade))
        end
    end
end
