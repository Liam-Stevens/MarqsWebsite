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
            #Assignments Left Counter
            if assignment.submissions.find_by(student_id: session[:id]).submitted_date == nil && Date.today < assignment.due_date
                @remaining_assignments = @remaining_assignments + 1
            end

            grades_and_weighting_helper(assignment)
        end

        calculate_grades()
        @grade_value = get_letter_grade(@current_grade)

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
