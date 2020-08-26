class SubmissionsController < ApplicationController
    def index
        # Get the id of the assignment we're viewing and get the object
        assignment_id = params[:assignment_id]
        @assignment = Assignment.find(assignment_id)
        
        # List out students 
        @students = Course.find(@assignment.course_id).students
    end

    def show
        # Get the object with the given id
        id = params[:id]
        @submission = Submission.find(id)
    end
end