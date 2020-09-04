class CommentsController < ApplicationController
    def create
        # Find submission with matching ID
        submission = Submission.find(params[:submission_id])

        # Create a comment and assign to submission
        comment = Comment.new
        comment.marker_id = Marker.all[0].id        # Get first marker for now
        comment.submission_id = submission.id
        comment.content = params[:text]
        comment.save!

        # Redirect to submission
        redirect_to submission_path(submission.id)
    end

    def new
        # Find submission with matching ID and get student
        submission = Submission.find(params[:submission_id])
        @student = submission.student
    end
end
