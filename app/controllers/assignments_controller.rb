include Errors

class AssignmentsController < ApplicationController
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
        if(headers == nil || headers != ["StudentID", "Fix-Final-Mark", "Feedback-Mark", "Feedback-Comments"])
            addError("please set headers to StudentID, Fix-Final-Mark, Feedback-Mark, Feedback-Comments")
            redirect_back(fallback_location: root_path)
            return
        end

        assignment = Assignment.find(params[:assignment_id])
        max_mark = assignment.max_points
        submissions = assignment.submissions

        # Setting students grades to imported grades
        csv.each do |row|
            submission = submissions.where(student_id: row["StudentID"]).first

            # Error if student is not found
            if(submission == nil)
                addError(row["StudentID"] + " " + "not found. Did not update")
                next
            end

            if (row["Fix-Final-Mark"] != nil)
                submission.grade = row["Fix-Final-Mark"]
            elsif (row["Feedback-Mark"] != nil)
                submission.grade = row["Feedback-Mark"]
            end
            
            if (!submission.save)
                addErrorArray(submission.errors.messages[:grade])
            end

            if (row["Feedback-Comments"] != nil)
                if (Comment.find_by(submission_id: submission.id, content: row["Feedback-Comments"]) == nil)
                    comment = Comment.new
                    comment.marker_id = session[:id]
                    comment.submission_id = submission.id
                    comment.content = row["Feedback-Comments"]
                    comment.save!
                end
            end
        end
        redirect_back(fallback_location: root_path)
    end

    def export
        assignment_id = params[:assignment_id]
        @assignment = Assignment.find(assignment_id)
        @submissions = @assignment.submissions.left_outer_joins(:comments).select("submissions.* , comments.*").group(:student_id)


        respond_to do |format|
            format.html
            format.csv { send_data Submission.to_csv(@submissions), filename: "#{@assignment.title}-#{Date.today}.csv" }
        end

    end
end
