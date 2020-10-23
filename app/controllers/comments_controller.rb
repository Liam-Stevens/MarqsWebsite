class CommentsController < ApplicationController
    def create
        # Get necessary IDs
        submission = Submission.find(params[:submission_id])
        @assignment = submission.assignment
        @course = @assignment.course

        # Redirect back to new page if comment is empty
        if params[:content].strip.empty?
            add_error("Can't add a blank comment")
            redirect_to new_submission_comment_path(submission)
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
        redirect_to submission_path(submission)
    end

    def new
        # Find submission with matching ID and get student
        @submission = Submission.find(params[:submission_id])
        @student = @submission.student

        # Get the assignment
        @assignment = @submission.assignment

        @is_marker = session[:marker]
        if @is_marker == false
            @person = Student.find(session[:id])
        else
            @person = Marker.find(session[:id])
        end

        @course = @assignment.course

        add_breadcrumb "Dashboard", marker_path(session[:id])
        add_breadcrumb "Course", course_marker_path(@course.id)
        add_breadcrumb "Assignment", assignment_path(@assignment.id)
        add_breadcrumb "Submission", submission_path(@submission.id)
        add_breadcrumb "Comment", :new_submission_comment_path
    end

    def edit
        # Find submission with matching ID and get student
        @submission = Submission.find(params[:submission_id])
        @student = @submission.student

        # Get the id of the assignment we're viewing and get the object
        @assignment = @submission.assignment

        @course = @assignment.course

        @comment = Comment.find(params[:id])

        add_breadcrumb "Dashboard", marker_path(session[:id])
        add_breadcrumb "Course", course_marker_path(@course.id)
        add_breadcrumb "Assignment", assignment_path(@assignment.id)
        add_breadcrumb "Submission", submission_path(@submission.id)
        add_breadcrumb "Comment", :edit_comment_path
    end

    def update
        # Get necessary IDs
        @submission = Submission.find(params[:submission_id])
        @assignment = @submission.assignment
        @course = @assignment.course
        @comment = Comment.find(params[:id])

        # Redirect back to edit page if comment is empty
        if params[:content].strip.empty?
            add_error("Can't set a blank comment")
            redirect_to edit_comment_path(@comment, :course_id => @course, :assignment_id => @assignment, :submission_id => @submission)
            return
        end

        # Edit comment values
        @comment.content = params[:content]
        @comment.save!
        flash[:notice] = "Comment updated."

        # Redirect to submission
        redirect_to submission_path(@submission)
    end

    def destroy
        @comment = Comment.find(params[:id])
        @comment.destroy!

        flash[:notice] = "Comment deleted."
        # Redirect to submission
        @submission = Submission.find(params[:submission_id])
        @assignment = @submission.assignment
        @course = @assignment.course
        redirect_to submission_path(@submission)
    end
end
