class CoursesController < ApplicationController
    def show
        # Get course object for ID
        id = params[:id]
        @is_marker = session[:marker]
        if @is_marker == false
            @person = Student.find(session[:id])
        else
            @person = Marker.find(session[:id])
        end

        @course = Course.find(id)

        # Get course's assignments and sort by due date
        @assignments = @course.assignments
        @assignments.order("due_date DESC")

        # Calculating students current grade
        @grades = []
        @max_grades = []
        @weightings = []

        @assignments.each do |assignment|
            grade = assignment.submissions.find_by(student_id: session[:id]).grade
            @max_grades.append(assignment.max_points)

            if(grade != nil)
                @grades.append(grade)
                @weightings.append(assignment.weighting)
            else
                @grades.append(0)
                @weightings.append(0)
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
                @grade_value = ("F")
            when 50..64
                @grade_value = ("P")
            when 65..74
                @grade_value = ("C")
            when 75..84
                @grade_value = ("D")
            when 85..100
                @grade_value = ("HD")
            else
                @grade_value = ("N/A")
                @current_grade = 0
        end
    end

    def show_marker
        # Get course object for ID
        id = params[:course_id]
        @is_marker = session[:marker]
        @person = Marker.find(session[:id])

        @course = Course.find(id)

        # Get course's assignments and sort by due date
        @assignments = @course.assignments
        @assignments.order("due_date DESC")
    end
end
