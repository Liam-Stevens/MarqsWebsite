require 'csv'

class SubmissionsController < ApplicationController
    def submission_params
        params.require(:submission).permit(:id, :assignment_id, :grade, :submitted_date)
    end

    def index
        # Get the id of the assignment we're viewing and get the object
        assignment_id = params[:assignment_id]
        @assignment = Assignment.find(assignment_id)

        # List out submissions
        @submissions = @assignment.submissions

        @is_marker = session[:marker]
        if @is_marker == false
            @person = Student.find(session[:id])
        else
            @person = Marker.find(session[:id])
        end

        @course = Course.find(params[:course_id])
    end

    def show
        # Get the object with the given id
        id = params[:id]
        @submission = Submission.where(assignment_id: params[:assignment_id], student_id: params[:student_id])[0]
        if (@submission == nil)
                @submission = Submission.find(id)
        end

        # Get the student
        @student = @submission.student

        # Get the submission's assignment
        @assignment = @submission.assignment

        # Get a list of the submission's comments
        @comments = @submission.comments
    end

    def edit
        # Get the submission
        id = params[:id]
        @submission = Submission.find(id)

        # Get the submission's assignment
        @assignment = @submission.assignment

        # Get the student
        @student = @submission.student

        @is_marker = session[:marker]
        if @is_marker == false
            @person = Student.find(session[:id])
        else
            @person = Marker.find(session[:id])
        end

        @course = Course.find(params[:course_id])
    end

    def update
        @submission = Submission.find params[:id]
        @submission.update_attributes!(submission_params)
        flash[:notice] = "#{@submission.student_id}'s submission was updated"

        redirect_to marker_course_assignment_submission_path(session[:id], params[:course_id], params[:assignment_id], @submission)
    end

    def import
        # Error if not a CSV file
        if(params[:grades] == nil || !params[:grades].path.match(".*.csv$"))
            flash[:notice] = "select CSV file"
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
            flash[:notice] = "please set headers to student_id, fix_final_mark, feedback_mark, comments"
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
                if(flash[:notice] == nil)
                    flash[:notice] = ""
                end
                flash[:notice] +=  "Error: student not found: " + row["student_id"]+ "    "
                next
            end

            # Error if marks are out of bounds
            if(row["fix_final_mark"].to_i > max_mark || row["fix_final_mark"].to_i < 0)
                if(flash[:notice] == nil)
                    flash[:notice] = ""
                end
                flash[:notice] +=  "Error: student mark are out of bounds: " + row["student_id"]+ "    "
                next
            end
            submission.grade = row["fix_final_mark"]
            submission.save!
        end
        redirect_back(fallback_location: root_path)
    end
end