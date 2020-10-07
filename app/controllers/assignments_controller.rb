include Errors

class AssignmentsController < ApplicationController
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
            return (array[mid - 1] + array[mid])/2
        else
            return array[array.length/2]
        end
    end

    def show
        # Get the id of the assignment we're viewing and get the object
        assignment_id = params[:id]
        @assignment = Assignment.find(assignment_id)

        # List out submissions
        @submissions = @assignment.submissions

        @course = @assignment.course
        @is_marker = session[:marker]
        if @is_marker == false
            redirect_to course_path(@course)
        else
            @person = Marker.find(session[:id])
            add_breadcrumb "Dashboard", marker_path(@person.id)
            add_breadcrumb "Course", course_marker_path(@course.id)
            add_breadcrumb "Assignment", :assignment_path
        end
    end

    # Get five number summary for assignment
    def summary
        # Get assignment and it's submissions for given ID
        assignment = Assignment.find(params[:assignment_id])
        grades = assignment.submissions.pluck(:grade)
        grades.compact!

        # Calculate relevant metrics and assign to hash
        grades.sort!
        summary = {};
        summary[:min] = grades[0]
        summary[:med] = get_median(grades)
        summary[:max] = grades[grades.length - 1]

        # Split in two and get their medians
        grades_left, grades_right = grades.each_slice((grades.length/2.0).round).to_a
        summary[:q1] = get_median(grades_left)
        summary[:q3] = get_median(grades_right)

        # Append other relevant info
        summary[:title] = assignment.title
        summary[:max_marks] = assignment.max_points

        # Return as a JSON
        render json: summary
    end

    def import
        # Error if not a CSV file
        if(params[:grades] == nil || !params[:grades].path.match(".*.csv$"))
            addError("select CSV file")
            redirect_back(fallback_location: root_path)
            return
        end

        # Read in CSV file and encode with utf-8
        uploaded_file = params[:grades]
        text = File.read(uploaded_file.path, :encoding => 'utf-8')
        csv = CSV.parse(text, :headers => true)
        headers = csv.headers

        # Error if file headers are incorrect
        if(headers == nil || headers != ["student_id", "fix_final_mark", "feedback_mark", "comments"])
            addError("please set headers to student_id, fix_final_mark, feedback_mark, comments")
            redirect_back(fallback_location: root_path)
            return
        end

        assignment = Assignment.find(params[:assignment_id])
        max_mark = assignment.max_points
        submissions = assignment.submissions

        # Setting students grades to imported grades
        csv.each do |row|
            submission = submissions.where(student_id: row["student_id"]).first

            # Error if student is not found
            if(submission == nil)
                addError(row["student_id"] + " " + "not found. Did not update")
                next
            end

            submission.grade = row["fix_final_mark"]
            if (!submission.save)
                addErrorArray(submission.errors.messages[:grade])
            end
        end
        redirect_back(fallback_location: root_path)
    end

    def export
        assignment_id = params[:assignment_id]
        @assignment = Assignment.find(assignment_id)
        @submissions = @assignment.submissions.left_outer_joins(:comments).select("submissions.* , comments.*")


        respond_to do |format|
            format.html
            format.csv { send_data Submission.to_csv(@submissions), filename: "#{@assignment.title}-#{Date.today}.csv" }
        end

    end
end
