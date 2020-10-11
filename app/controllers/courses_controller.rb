class CoursesController < ApplicationController

    def show
        # Get course object for ID
        id = params[:id]
        add_breadcrumb "Dashboard", student_path(session[:id])
        add_breadcrumb "Course", :course_path
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
        @remaining_assignments = 0

        @assignments.each do |assignment|
            @submission = assignment.submissions.find_by(student_id: session[:id])
            @max_grades.append(assignment.max_points)
            grade = @submission.grade

            #Assignments Left Counter
            if assignment.submissions.find_by(student_id: session[:id]).submitted_date == nil && Date.today < assignment.due_date
                @remaining_assignments = @remaining_assignments + 1
            end

            if (grade == nil)
                @grades.append(0)
                @weightings.append(0)
                next
            end

            @grades.append(grade)
            @weightings.append(assignment.weighting)

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

        @grade_value = get_letter_grade(@current_grade)

        if(get_letter_grade(@current_grade) == "N/A")
            @current_grade = 0
        end

    end

    def show_marker
        # Get course object for ID
        id = params[:course_id]
        @person = Marker.find(session[:id])

        @course = Course.find(id)

        add_breadcrumb "Dashboard", marker_path(@person.id)
        add_breadcrumb "Course", course_marker_path(@course.id)

        # Get course's assignments and sort by due date
        @assignments = @course.assignments
        @assignments.order("due_date DESC")
    end
end
