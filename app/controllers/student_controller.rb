class StudentController < ApplicationController

  def index
      @courses = Student.all
  end

end
