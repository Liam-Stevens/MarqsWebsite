include Errors

class AdminController < ApplicationController
  before_action :check_admin_session

  def check_admin_session
    if session[:id] != "1000000"
      redirect_to root_path
    end 
  end

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

  def show
    @type = params[:id]
    if @type != "course" && @type != "student" && @type != "marker" && @type != "assignment"
      redirect_to admin_index_path
    end

    add_breadcrumb "Manager", admin_index_path
    add_breadcrumb "Manage "+@type+"s", admin_path(:id => @type)

    @courses = (Course.all).reorder(:long_title)
    @students = Student.all.reorder(:student_id)
    @markers = Marker.all.reorder(:marker_id)
    @assignments = (Assignment.all).reorder(:course_id)

  end

  def create
    if params[:commit] == "Add Course"
      if Course.find_by(course_id: params[:Course_ID]) == nil
        course = Course.new
        course.eff_date = params[:Eff_Date]
        course.course_id = params[:Course_ID]
        course.short_title = params[:Short_Title]
        course.long_title = params[:Long_Title]
        course.descr = params[:Descr]
        course.subject = params[:Subject]
        course.save!

        redirect_to admin_index_path
        add_error("#{course.course_id}: #{course.long_title} added succesfully!")
      else
        add_error("Course already exists")
        redirect_to new_admin_path(:type => "course")
      end
    elsif params[:commit] == "Add Student"
      if (Marker.find_by(marker_id: params[:Student_ID]) == nil && Student.find_by(student_id: params[:Student_ID]) == nil)
        student = Student.new
        student.student_id = params[:Student_ID]
        student.first_name = params[:First_Name]
        student.last_name = params[:Last_Name]

        if (params[:Course_id] != nil)
          courses = []
          params[:Course_id].each do |course|
              courses.push(Course.find(course.to_i))
          end
          student.courses = courses
        end
        student.save!

        #add submission for each assignment
        if (courses != nil)
          courses.each do |course|
            assignment = course.assignments
            assignment.each do |assignment|
              submission = Submission.new
              submission.student_id = student.student_id
              submission.assignment_id = assignment.id
              submission.save!

              assignment.submissions << submission
            end
          end
        end

        redirect_to admin_index_path
        add_error("#{student.student_id}: #{student.first_name} #{student.last_name} added succesfully!")
      else
        add_error("User ID already exists")
        redirect_to new_admin_path(:type => "student")
      end
    elsif params[:commit] == "Add Marker"
      if (Marker.find_by(marker_id: params[:Marker_ID]) == nil && Student.find_by(student_id: params[:Marker_ID]) == nil)
        marker = Marker.new
        marker.marker_id = params[:Marker_ID]
        marker.first_name = params[:First_Name]
        marker.last_name = params[:Last_Name]

        if (params[:Course_id] != nil)
          courses = []
          params[:Course_id].each do |course|
              courses.push(Course.find(course.to_i))
          end
          marker.courses = courses
        end

        marker.save!
        redirect_to admin_index_path
        add_error("#{marker.marker_id}: #{marker.first_name} #{marker.last_name} added succesfully!")
      else
        add_error("User ID already exists")
        redirect_to new_admin_path(:type => "marker")
      end
    elsif params[:commit] == "Add Assignment"
      if Course.find_by(course_id: params[:Course_id]) != nil
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
        add_error("#{assignment.title} added succesfully!")
      else
        add_error("Course not Found")
        redirect_to new_admin_path(:type => "assignment")
      end
    end
  end

  def edit
    @type = params[:id]
    @name = "FAILED TO FIND"

    add_breadcrumb "Manager", admin_index_path
    add_breadcrumb "Manage "+@type+"s", admin_path(:id => @type)
    add_breadcrumb "Edit a "+@type, edit_admin_path(:id => @type, :find => params[:find])

    if (@type != "course" && @type != "student" && @type != "marker" && @type != "assignment") || (params[:find] == nil)
      redirect_to admin_index_path
    elsif @type == "course"
      @this_course = Course.find(params[:find])
      @name = @this_course.long_title
    elsif @type == "student"
      @this_student = Student.find(params[:find])
      @name = @this_student.first_name + " " + @this_student.last_name
    elsif @type == "marker"
      @this_marker = Marker.find(params[:find])
      @name = @this_marker.first_name + " " + @this_marker.last_name
    elsif @type == "assignment"
      @this_assignment = Assignment.find(params[:find])
      @name = @this_assignment.title
    end

    @courses = Course.all

  end

  def update
    @type = params[:commit]
    if (@type != "Save Course" && @type != "Save Student" && @type != "Save Marker" && @type != "Save Assignment") || (params[:find] == nil)
      redirect_to admin_index_path
    elsif @type == "Save Course"
      course = Course.find_by(course_id: params[:find])
      if course != nil
        course.eff_date = params[:Eff_Date]
        course.short_title = params[:Short_Title]
        course.long_title = params[:Long_Title]
        course.descr = params[:Descr]
        course.subject = params[:Subject]
        course.save!

        redirect_to edit_admin_path(:type => @type)
        add_error("Course edited succesfully!")
      else
        add_error("Course not found")
        redirect_to edit_admin_path(:type => @type)
      end

    elsif @type == "Save Student"
      student = Student.find_by(student_id: params[:find])
      if student != nil
        student.first_name = params[:First_Name]
        student.last_name = params[:Last_Name]

        courses = []
        params[:Course_id].each do |course|
          courses.push(Course.find(course.to_i))

        end
        student.courses = courses
        student.save!

        #TODO: Delete the submissions from removed courses?
        #add submission for each assignment
        courses.each do |course|
          assignment = course.assignments
          assignment.each do |assignment|
            newSub = true
            submission = assignment.submissions
            submission.each do |submission|
              if submission.student_id == student.student_id
                newSub = false
              end
            end
            if newSub == true
              submission = Submission.new
              submission.student_id = student.student_id
              submission.assignment_id = assignment.id
              submission.save!

              assignment.submissions << submission
            end
         end
        end

        add_error("Student edited succesfully!")
        redirect_to edit_admin_path(:type => @type)
      else
        add_error("Student not found")
        redirect_to edit_admin_path(:type => @type)
      end

    elsif @type == "Save Marker"
      marker = Marker.find_by(marker_id: params[:find])
      if marker != nil
        marker = Marker.new
        marker.first_name = params[:First_Name]
        marker.last_name = params[:Last_Name]

        courses = []
        params[:Course_id].each do |course|
          courses.push(Course.find(course.to_i))
        end
        marker.courses = courses

        marker.save!

        add_error("Marker edited succesfully!")
        redirect_to edit_admin_path(:type => @type)
      else
        add_error("Marker not found")
        redirect_to edit_admin_path(:type => @type)
      end

    elsif @type == "Save Assignment"
      assignment = Assignment.find(params[:find])
      if assignment != nil
        assignment.course = Course.find(params[:Course_id])
        assignment.title = params[:Title]
        assignment.due_date = params[:Date]
        assignment.weighting = params[:Weighting]
        assignment.max_points = params[:Max_points]
        assignment.save!

        add_error("Assignment edited succesfully!")
        redirect_to edit_admin_path(:type => @type)
      else
        add_error("Assignment not found")
        redirect_to edit_admin_path(:type => @type)
      end

    end

  end

  def destroy
    if params[:id] == "course"
      myCourse = Course.find(params[:course])
      if myCourse != nil
        courseID = myCourse.id
        courseName = myCourse.short_title

        myCourse.destroy
        add_error("#{courseID}: #{courseName} removed")
      else
        add_error("Course not found")
      end

      redirect_to admin_path(:id => params[:id])
    elsif params[:id] == "student"
      myStudent = Student.find(params[:student])
      if myStudent != nil
        studentID = myStudent.id
        studentName = myStudent.first_name + " " + myStudent.last_name

        myStudent.destroy
        add_error("#{studentID}: #{studentName} removed")
      else
        add_error("Student not found")
      end

      redirect_to admin_path(:id => params[:id])
    elsif params[:id] == "marker"
      myMarker = Marker.find(params[:marker])
      if myMarker != nil
        markerID = myMarker.id
        markerName = myMarker.first_name + " " + myMarker.last_name
        myMarker.destroy

        add_error("#{markerID}: #{markerName} removed")
      else
        add_error("Marker not found")
      end

      redirect_to admin_path(:id => params[:id])
    elsif params[:id] == "assignment"
      myAssignment = Assignment.find(params[:assignment])
      if myAssignment != nil
        assignmentID = myAssignment.id
        assignmentName = myAssignment.title

        myAssignment.destroy
        add_error("#{assignmentID}: #{assignmentName} removed")
      else
        add_error("Assignment not found")
      end

      redirect_to admin_path(:id => params[:id])
    else
      redirect_to admin_index_path
    end
  end

end
