class StudentsController < ApplicationController
    def show
        # Redirect for wrong URI
        if session[:id] != params[:id]
            redirect_to login_path
        end

        # Pass list of courses
        @courses = @logged_in_user.courses

        @all_grade = []
        @grade_value = []

        # Calculating students grade for each course
        @courses.each do |course|
            @assignments = course.assignments

            @grades = []
            @max_grades = []
            @weightings = []

            @assignments.each do |assignment|
                grades_and_weighting_helper(assignment)
            end

            calculate_grades()
            @grade_value.append(get_letter_grade(@current_grade))
            @all_grade.append(@current_grade)

        end

    end
end
