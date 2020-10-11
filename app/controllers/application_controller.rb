class ApplicationController < ActionController::Base
    # Call below function before rendering the template
    layout 'application'
    before_action :check_authenticated
    before_action :get_logged_in_user
    before_action :redirect_to_root

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
        if !@logged_in && session[:ignore_redirect] == false
            redirect_to root_path
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

    def grades_and_weighting_helper(assignment)
        @submission = assignment.submissions.find_by(student_id: session[:id])
        @max_grades.append(assignment.max_points)
        grade = @submission.grade

        if(grade != nil)
            @grades.append(grade)
            @weightings.append(assignment.weighting)
        else
            @grades.append(0)
            @weightings.append(0)
        end
    end

    def calculate_grades_helper
        @sum_grade = 0
        @sum_weightings = 0

        @grades.each_with_index do |grade,index|
            @sum_grade += (@grades[index].to_f/@max_grades[index].to_f)*(@weightings[index]*100)
            @sum_weightings += @weightings[index]*100
        end

        if(@sum_weightings == 0)
            @current_grade = -1
        else
            @current_grade = ((@sum_grade/@sum_weightings)*100).floor
        end

    end
end
