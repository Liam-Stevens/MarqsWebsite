class SubmissionsController < ApplicationController
    def index
        # Get the id of the assignment we're viewing and get the object
        assignment_id = params[:assignment_id]
        @assignment = Assignment.find(assignment_id)

        # List out submissions
        @submissions = @assignment.submissions
    end

    def show
        # Get the object with the given id
        id = params[:id]
        @submission = Submission.find(id)

        # Get the submission's assignment
        @assignment = @submission.assignment

        # Get a list of the submission's comments
        @comments = @submission.comments
    end
end