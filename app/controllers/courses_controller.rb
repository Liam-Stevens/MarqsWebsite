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

        @grades = []
        @max_grades = []
        @weightings = []
        @assignments.each do |assignment|
            grade = assignment.submissions.find_by(student_id: session[:id]).grade
            @max_grades.append(assignment.max_points)
            @weightings.append(assignment.weighting)
            if(grade == nil)
                @grades.append(0)
            else
                @grades.append(grade)
            end
        end

        @sum_grade = 0
        @sum_weightings = 0
        @grades.each_with_index do |grade,index|
            @sum_grade += @grades[index]/@max_grades[index]*@weightings[index]
            @sum_weightings += @weightings[index]
        end

        @current_grade = (@sum_grade/(@sum_weightings))*100
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
