class AdminController < ApplicationController
  def index
    add_breadcrumb "Manager", admin_index_path
  end

  def new
    @type = params[:type]
    if @type != "course" && @type != "student" && @type != "marker" && @type != "assignment"
      redirect_to admin_index_path
    end

    add_breadcrumb "Manager", admin_index_path
    add_breadcrumb "Add new "+@type, new_admin_path(:type => @type)

  end

  def create
    if params[:commit] == "Add Course"
      course = Course.new
      course.eff_date = params[:Eff_Date]
      course.course_id = params[:Course_ID]
      course.short_title = params[:Song_Title]
      course.long_title = params[:Long_Title]
      course.descr = params[:Descr]
      course.subject = params[:Subject]
      course.save!
    end

    redirect_to admin_index_path
  end
end
