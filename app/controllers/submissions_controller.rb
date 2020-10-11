require 'csv'
include Errors

class SubmissionsController < ApplicationController

    def submission_params
        params.require(:submission).permit(:id, :assignment_id, :grade, :submitted_date)
    end

    def show
        # Get the object with the given id
        id = params[:id]
        @submission = Submission.where(assignment_id: params[:assignment_id], student_id: @logged_in_user.id)[0]
        if @submission == nil
            @submission = Submission.find(id)
        end

        # Get the submission's assignment
        @assignment = @submission.assignment

        @is_marker = session[:marker]
        if @is_marker == false
            add_breadcrumb "Dashboard", student_path(session[:id])
            add_breadcrumb "Course", course_path(@assignment.course)
            add_breadcrumb "Submission", :submission_path
        else
            add_breadcrumb "Dashboard", marker_path(session[:id])
            add_breadcrumb "Course", course_marker_path(@assignment.course)
            add_breadcrumb "Assignment", assignment_path(@assignment.id)
            add_breadcrumb "Submission", :submission_path
        end

        # Get a list of the submission's comments
        @comments = @submission.comments

        # Format a string containing grade
        if @submission.grade == nil || @assignment.max_points == nil
            @grade_string = "N/A"
        else
            ratio = 100 * (@submission.grade / @assignment.max_points.to_f)
            ratio = ratio.round(1)
            @grade_string = "#{@submission.grade}/#{@assignment.max_points} (#{ratio}%)"
        end
    end

    def edit
        # Get the submission
        id = params[:id]
        @submission = Submission.find(id)

        # Get the submission's assignment
        @assignment = @submission.assignment

        # Get the student
        @student = @submission.student

        @is_marker = session[:marker]
        if @is_marker == false
            @person = Student.find(session[:id])
        else
            @person = Marker.find(session[:id])
            add_breadcrumb "Dashboard", marker_path(session[:id])
            add_breadcrumb "Course", course_marker_path(@assignment.course)
            add_breadcrumb "Assignment", assignment_path(@assignment.id)
            add_breadcrumb "Submission", :submission_path
            add_breadcrumb "Grade", :edit_submission_path
        end

        @course = @submission.assignment.course
    end


    #Updates grade
    def update
        # Redirect back to same page if blank grade given
        if submission_params[:grade].strip.empty?
            addError("Unable to set a blank grade")
            redirect_to edit_submission_path(params[:id]) and return
        end

        @submission = Submission.find params[:id]
        @submission.grade = submission_params[:grade]

        if @submission.save
            flash[:notice] = "#{@submission.student_id}'s submission was updated"
            redirect_to submission_path(@submission)
        else
            addErrorArray(@submission.errors.messages[:grade])
            redirect_to edit_submission_path(@submission)
        end
    end


end
