class CoursesController < ApplicationController
    helper_method :get_median

    # Return the median value in the given (sorted) array
    def get_median(array)
        # Edge case: empty
        if (array.empty?)
            return nil
        end

        # Handle even/odd sizes
        if (array.length % 2 == 0)
            mid = array.length/2
            return (array[mid - 1] + array[mid])/2.0
        else
            return array[array.length/2]
        end
    end

    # Get five number summary for a course
    def summary
        course = Course.find(params[:course_id])
        grades = []

        # Calculate all students grades for this course
        students = Student.all
        students.each do |student|
            grade = student.calculate_grade(course)

            # Eliminate grades of zero
            if (grade > 0)
                grades.append(grade)
            end
        end
        grades.compact!
        puts grades

        # Return blank JSON if no grades
        if (grades.empty?)
            render json: "{}"
            return
        end

        # Calculate relevant metrics and assign to hash
        grades.sort!
        summary = {};
        summary[:min] = grades[0]
        summary[:med] = get_median(grades)
        summary[:max] = grades[grades.length - 1]
        summary[:avg] = grades.sum/grades.length.to_f

        # Split in two and get their medians
        grades_left, grades_right = grades.each_slice((grades.length/2.0).round).to_a
        if (grades_left == nil || grades_right == nil)
            summary[:q1] = grades[0]
            summary[:q3] = grades[0]
        else
            summary[:q1] = get_median(grades_left)
            summary[:q3] = get_median(grades_right)
        end

        # Append other relevant info
        summary[:title] = course.long_title

        # Return as a JSON
        render json: summary
    end

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
            if (@submission == nil)
                @grades.append(0)
                @weightings.append(0)
                next
            end
            grade = @submission.grade

            if(grade != nil)
                @grades.append(grade)
                @weightings.append(assignment.weighting)
            end

            #Assignments Left Counter
            if assignment.submissions.find_by(student_id: session[:id]).submitted_date == nil && Date.today < assignment.due_date
                @remaining_assignments = @remaining_assignments + 1
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
        @person = Marker.find(session[:id])

        @course = Course.find(id)

        add_breadcrumb "Dashboard", marker_path(@person.id)
        add_breadcrumb "Course", course_marker_path(@course.id)

        # Get course's assignments and sort by due date
        @assignments = @course.assignments
        @assignments.order("due_date DESC")
    end
end
