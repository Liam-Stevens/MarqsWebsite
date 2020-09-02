class StudentsController < ApplicationController

    def show
        id = params[:id]
        @student = Student.find(id)
        @studentName = @student.first_name + " " + @student.last_name
        @courses = @student.courses
    end
    
end
