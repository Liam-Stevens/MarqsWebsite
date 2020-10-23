class ApplicationController < ActionController::Base
    # Call below function before rendering the template
    layout 'application'
    before_action :check_authenticated
    before_action :get_logged_in_user
    before_action :redirect_to_root

    # Format a float
    def format_grade(grade)
        # Skip over blank
        if grade == nil
            return grade
        end

        grade = grade.round(2)
        str = grade.to_s
        if str[str.length - 1] == '0'
            grade = grade.floor
        end
        return grade
    end

    # Checks if a user is logged in and redirects to home page if not
    def check_authenticated
        @logged_in = session[:logged_in]
    end

    # Passes logged in user to template
    def get_logged_in_user
        if @logged_in
            if Student.exists?(session[:id])
                @logged_in_user = Student.find(session[:id])
            elsif Marker.exists?(session[:id])
                @logged_in_user = Marker.find(session[:id])
            end
        end
    end

    # Redirect to root if not logged in
    def redirect_to_root
        if @logged_in == false || session[:ignore_redirect] == true
            redirect_to root_path
        end
    end

    def show_session_redirect
        if params[:id] != session[:id]
            if session[:id] == "1000000"
                redirect_to admin_index_path
            elsif Student.exists?(session[:id])
                redirect_to student_path(session[:id])
            elsif Marker.exists?(session[:id])
                redirect_to marker_path(session[:id])
            end
        end
    end

    def get_letter_grade(current_grade)
        case current_grade
            when 0..49
                return "F"
            when 50..64
                return "P"
            when 65..74
                return "C"
            when 75..84
                return "D"
            when 85..100
                return "HD"
            else
                return "N/A"
        end
    end

    def grades_and_weighting_helper(assignment,student)
        @submission = assignment.submissions.find_by(student_id: student.student_id)
        @max_grades.append(assignment.max_points)
        grade = format_grade(@submission.grade)
        date = @submission.submitted_date

        if grade != nil
            @grades.append(grade)
            @weightings.append(assignment.weighting)
        elsif date == nil && Date.today >= assignment.due_date
            @grades.append(0)
            @weightings.append(assignment.weighting)
        elsif date != nil && date >= assignment.due_date
            @grades.append(0)
            @weightings.append(assignment.weighting)
        else
            @grades.append(0)
            @weightings.append(0)
        end
    end

    def calculate_grades
        @sum_grade = 0
        @sum_weightings = 0

        @grades.each_with_index do |grade,index|
            @sum_grade += (@grades[index].to_f/@max_grades[index].to_f)*(@weightings[index]*100)
            @sum_weightings += @weightings[index]*100
        end

        if @sum_weightings == 0
            @current_grade = -1
        else
            @current_grade = (@sum_grade/@sum_weightings)*100
        end

        @current_grade = format_grade(@current_grade)
    end
end
