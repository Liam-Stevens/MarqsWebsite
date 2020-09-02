class StudentsController < ApplicationController

    def index
        #Redirect for wrong URI
        if session[:id] != params[:id]
            redirect_to "/login"
        end

        id = session[:id]
        @student = Student.find(id)
    end

    def show
        #Redirect for wrong URI
        if session[:id] != params[:id]
            redirect_to "/login"
        end

        id = session[:id]
        @student = Student.find(id)
        @studentName = @student.first_name + " " + @student.last_name
        @courses = @student.courses
        @assignments = @courses[0].assignments
    end

    def course
        #Redirect for wrong URI
        if session[:id] != params[:id]
            redirect_to "/login"
        end

        id = session[:id]
        @student = Student.find(id)
    end
end
