class CoursesController < ApplicationController

    def show
<<<<<<< HEAD
        @student = Student.find(params[:student_id])
        @course = Course.find(params[:id])
=======
        id = params[:id]
        @is_marker = session[:marker]
        if @is_marker == false
            @person = Student.find(session[:id])
        else
            @person = Marker.find(session[:id])
        end

        @course = Course.find(id)
>>>>>>> sessions
        @assignments = @course.assignments
    end

end
