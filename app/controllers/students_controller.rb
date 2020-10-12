class StudentsController < ApplicationController
    def show
        add_breadcrumb "Dashboard", student_path(session[:id])
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
            current_grade = @logged_in_user.calculate_grade(course)

            case current_grade
                when 0..49
                    @grade_value.append("F")
                when 50..64
                    @grade_value.append("P")
                when 65..74
                    @grade_value.append("C")
                when 75..84
                    @grade_value.append("D")
                when 85..100
                    @grade_value.append("HD")
                else
                    @grade_value.append("N/A")
                    current_grade = 0
            end

            @all_grade.append(current_grade)
        end
    end
end
