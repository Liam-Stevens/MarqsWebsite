class StudentsController < ApplicationController
    add_breadcrumb "Dashboard", :marker_path

    def show
        # Redirect for wrong URI
        if session[:id] != params[:id]
            redirect_to login_path
        end

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
    end
end
