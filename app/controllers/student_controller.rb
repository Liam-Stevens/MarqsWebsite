class StudentController < ApplicationController

  def show
    @student = Student.find(params[:id])
    @courses = @student.courses
  end

end
