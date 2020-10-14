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
      if (Course.find_by(course_id: params[:Course_ID]) == nil)
        course = Course.new
        course.eff_date = params[:Eff_Date]
        course.course_id = params[:Course_ID]
        course.short_title = params[:Short_Title]
        course.long_title = params[:Long_Title]
        course.descr = params[:Descr]
        course.subject = params[:Subject]
        course.save!
        redirect_to admin_index_path
      else
        add_error("Course already exists")
        redirect_to new_admin_path(:type => "course")
      end
    elsif params[:commit] == "Add Assignment"
      if (Course.find_by(course_id: params[:Course_id]) != nil)
        assignment = Assignment.new
        assignment.course = Course.find(params[:Course_id])
        assignment.title = params[:Title]
        assignment.due_date = params[:Date]
        assignment.weighting = params[:Weighting]
        assignment.max_points = params[:Max_points]
        assignment.save!
        
        #add submission for each student
        students = Course.find(params[:Course_id]).students
        students.each do |student|
            submission = Submission.new
            submission.student_id = student.student_id
            submission.assignment_id = assignment.id
            submission.save!
            
            assignment.submissions << submission
        end
        
        redirect_to admin_index_path
      else
        add_error("Course not Found")
        redirect_to new_admin_path(:type => "assignment")
      end
    elsif params[:commit] == "Add Student"
      if (Student.find_by(student_id: params[:Student_ID]) == nil)
        student = Student.new
        student.student_id = params[:Student_ID]
        student.first_name = params[:First_Name]
        student.last_name = params[:Last_Name]

        courses = []
        params[:Course_id].each do |course|
            courses.push(Course.find(course.to_i))
        end
        student.courses = courses

        student.save!
        redirect_to admin_index_path
      else
        add_error("Student already exists")
        redirect_to new_admin_path(:type => "student")
      end
    elsif params[:commit] == "Add Marker"
      if (Marker.find_by(marker_id: params[:Marker_ID]) == nil)
        marker = Marker.new
        marker.marker_id = params[:Marker_ID]
        marker.first_name = params[:First_Name]
        marker.last_name = params[:Last_Name]

        courses = []
        params[:Course_id].each do |course|
            courses.push(Course.find(course.to_i))
        end
        student.courses = courses

        marker.save!
        redirect_to admin_index_path
      else
        add_error("Marker already exists")
        redirect_to new_admin_path(:type => "marker")
      end
    end
  end
end
