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
        @submission = Submission.where(assignment_id: params[:assignment_id], student_id: params[:student_id])[0]
        if (@submission == nil)
                @submission = Submission.find(id)
        end

        @student = @submission.student

        # Get the submission's assignment
        @assignment = @submission.assignment

        # Get a list of the submission's comments
        @comments = @submission.comments
    end
end