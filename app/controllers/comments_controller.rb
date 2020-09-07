class CommentsController < ApplicationController
    def create
        # Find submission with matching ID
        submission = Submission.find(params[:submission_id])

        # Create a comment and assign to submission
        comment = Comment.new
        comment.marker_id = session[:id]
        comment.submission_id = submission.id
        comment.content = params[:text]
        comment.save!

        assignment_id = params[:assignment_id]
        @assignment = Assignment.find(assignment_id)

        @is_marker = session[:marker]
        if @is_marker == false
            @person = Student.find(session[:id])
        else
            @person = Marker.find(session[:id])
        end

        @course = Course.find(params[:course_id])

        # Redirect to submission
        redirect_to marker_course_assignment_submission_path(@person, @course, @assignment, submission)
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
end
