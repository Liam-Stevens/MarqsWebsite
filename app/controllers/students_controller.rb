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
            @assignments = course.assignments

            @grades = []
            @max_grades = []
            @weightings = []

            @assignments.each do |assignment|
                submission = assignment.submissions.find_by(student_id: session[:id])
                @max_grades.append(assignment.max_points)
                if (submission == nil)
                    @grades.append(0)
                    @weightings.append(0)
                    next
                end
                grade = submission.grade

                if(grade != nil)
                    @grades.append(grade)
                    @weightings.append(assignment.weighting)
                end
            end

            @sum_grade = 0
            @sum_weightings = 0

            @grades.each_with_index do |grade,index|
                @sum_grade += (@grades[index].to_f/@max_grades[index].to_f)*(@weightings[index]*100)
                @sum_weightings += @weightings[index]*100
            end

            if(@sum_weightings == 0)
                @current_grade = -1
            else
                @current_grade = ((@sum_grade/@sum_weightings)*100).floor
            end

            case @current_grade
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
                    @current_grade = 0
            end
            @all_grade.append(@current_grade)

        end

    end
end
