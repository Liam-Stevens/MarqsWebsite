class StudentsController < ApplicationController

    def index
    id = params[:id]
    @student = Student.find(id)
    end

    def show
    id = params[:id]
    @student = Student.find(id)
    @studentName = @student.first_name + " " + @student.last_name
    @courses = @student.courses
    @assignments = @courses[0].assignments
    end

end
