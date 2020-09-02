class CoursesController < ApplicationController

    def show
        id = params[:id]
        @is_marker = session[:marker]
        if @is_marker == false
            @person = Student.find(session[:id])
        else
            @person = Marker.find(session[:id])
        end

        @course = Course.find(id)
        @assignments = @course.assignments
    end

end
