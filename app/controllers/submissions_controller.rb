require 'csv'
include Errors

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

        @course = Course.find(params[:course_id])
        @is_marker = session[:marker]
        if @is_marker == false
            redirect_to course_path(@course)
        else
            @person = Marker.find(session[:id])
        end


    end

    def show
        # Get the object with the given id
        id = params[:id]
        @submission = Submission.where(assignment_id: params[:assignment_id], student_id: @logged_in_user.id)[0]
        if (@submission == nil)
            @submission = Submission.find(id)
        end

        # Get the student
        @student = @submission.student

        # Get the submission's assignment
        @assignment = @submission.assignment

        # Get a list of the submission's comments
        @comments = @submission.comments

        # Format a string containing grade
        if (@submission.grade == nil || @assignment.max_points == nil) then
            @grade_string = "N/A"
        else
            ratio = 100 * (@submission.grade / @assignment.max_points.to_f)
            ratio = ratio.round(1)
            @grade_string = "#{@submission.grade}/#{@assignment.max_points} (#{ratio}%)"
        end
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


    #Updates grade
    def update
        # Redirect back to same page if blank grade given
        if submission_params[:grade].strip.empty?
            addError("Unable to set a blank grade")
            redirect_to edit_course_assignment_submission_path(params[:course_id], params[:assignment_id], params[:id])
            return
        end

        @submission = Submission.find params[:id]
        @submission.grade = submission_params[:grade]

        if @submission.save
            flash[:notice] = "#{@submission.student_id}'s submission was updated"
            redirect_to course_assignment_submission_path(params[:course_id], params[:assignment_id], @submission)
            return
        else
            addErrorArray(@submission.errors.messages[:grade])
            redirect_to edit_course_assignment_submission_path(params[:course_id], params[:assignment_id], @submission)
            return
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
end