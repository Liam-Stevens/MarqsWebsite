class CoursesController < ApplicationController
    def show
        # Get course object for ID
        id = params[:id]
        @course = Course.find(id)

        # Get course's assignments and sort by due date
        @assignments = @course.assignments
        @assignments.order("due_date DESC")
    end
end
