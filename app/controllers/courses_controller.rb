class CoursesController < ApplicationController

    def show
        id = params[:id]
        @course = Course.find(id)
        @assignments = @course.assignments
    end

end
