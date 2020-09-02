class CoursesController < ApplicationController

    def show
        @student = Student.find(params[:student_id])
        @course = Course.find(params[:id])
        @assignments = @course.assignments
    end

end
