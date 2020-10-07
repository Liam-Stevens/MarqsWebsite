include Errors

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

    @courses = Course.all

  end

  def create
    if params[:commit] == "Add Course"
      course = Course.new
      course.eff_date = params[:Eff_Date]
      course.course_id = params[:Course_ID]
      course.short_title = params[:Short_Title]
      course.long_title = params[:Long_Title]
      course.descr = params[:Descr]
      course.subject = params[:Subject]
      course.save!
      redirect_to admin_index_path
    elsif params[:commit] == "Add Assignment"
      if (Course.find_by(course_id: params[:Course_id]) != nil)
        assignment = Assignment.new
        assignment.course = Course.find(params[:Course_id])
        assignment.title = params[:Title]
        assignment.due_date = params[:Date]
        assignment.weighting = params[:Weighting]
        assignment.max_points = params[:Max_points]
        assignment.save!
        redirect_to admin_index_path
      else
        addError("Course not Found")
        redirect_to new_admin_path(:type => "assignment")
      end
    end
  end
end
