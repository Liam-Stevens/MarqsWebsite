class StudentController < ApplicationController

  def index
      @courses = Course.all
  end

end
