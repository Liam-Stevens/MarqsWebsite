class CommentsController < ApplicationController
    def create
        # Get necessary IDs
        @course = Course.find(params[:course_id])
        @assignment = Assignment.find(params[:assignment_id])
        submission = Submission.find(params[:submission_id])

        # Redirect back to new page if comment is empty
        if params[:content].strip.empty?
            addError("Can't add a blank comment")
            redirect_to new_course_assignment_submission_comment_path(@course, @assignment, submission)
            return
        end

        # Create a comment and assign to submission
        comment = Comment.new
        comment.marker_id = session[:id]
        comment.submission_id = submission.id
        comment.content = params[:content]
        comment.save!

        @is_marker = session[:marker]
        if @is_marker == false
            @person = Student.find(session[:id])
        else
            @person = Marker.find(session[:id])
        end

        # Redirect to submission
        redirect_to course_assignment_submission_path(@course, @assignment, submission)
    end

    def new
        # Find submission with matching ID and get student
        @submission = Submission.find(params[:submission_id])
        @student = @submission.student

        # Get the id of the assignment we're viewing and get the object
        assignment_id = params[:assignment_id]
        @assignment = Assignment.find(assignment_id)

        @is_marker = session[:marker]
        if @is_marker == false
            @person = Student.find(session[:id])
        else
            @person = Marker.find(session[:id])
        end

        @course = Course.find(params[:course_id])
    end

    def edit
        # Find submission with matching ID and get student
        @submission = Submission.find(params[:submission_id])
        @student = @submission.student

        # Get the id of the assignment we're viewing and get the object
        assignment_id = params[:assignment_id]
        @assignment = Assignment.find(assignment_id)

        @course = Course.find(params[:course_id])

        @comment = Comment.find(params[:id])
    end

    def update
        # Get necessary IDs
        @course = Course.find(params[:course_id])
        @assignment = Assignment.find(params[:assignment_id])
        @submission = Submission.find(params[:submission_id])
        @comment = Comment.find(params[:id])

        # Redirect back to edit page if comment is empty
        if params[:content].strip.empty?
            addError("Can't change to a blank comment")
            redirect_to edit_comment_path(@comment, :course_id => @course, :assignment_id => @assignment, :submission_id => @submission)
            return
        end

        # Edit comment values
        @comment.content = params[:content]
        @comment.save!
        flash[:notice] = "Comment updated."

        # Redirect to submission
        redirect_to course_assignment_submission_path(@course, @assignment, @submission)
    end

    def destroy
        @comment = Comment.find(params[:id])
        @comment.destroy!

        flash[:notice] = "Comment deleted."
        # Redirect to submission
        @course = Course.find(params[:course_id])
        @assignment = Assignment.find(params[:assignment_id])
        @submission = Submission.find(params[:submission_id])
        redirect_to course_assignment_submission_path(@course, @assignment, @submission)
    end
end
