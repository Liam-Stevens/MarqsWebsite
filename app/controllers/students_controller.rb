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

            calculate_grades_helper()

            @grade_value.append(get_letter_grade(@current_grade))
        
            if(get_letter_grade(@current_grade) == "N/A")
                @current_grade = 0
            end

            @all_grade.append(@current_grade)

        end

    end
end
