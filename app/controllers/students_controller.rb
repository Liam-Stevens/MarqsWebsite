class StudentsController < ApplicationController
  
    def show
        #Redirect for wrong URI
        if session[:id] != params[:id]
            redirect_to "/login"
        end

        id = session[:id]
        @student = Student.find(id)
        @studentName = @student.first_name + " " + @student.last_name
        @courses = @student.courses
    end
    
end
