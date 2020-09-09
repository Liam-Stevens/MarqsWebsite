class StudentsController < ApplicationController
    def show
        # Redirect for wrong URI
        if session[:id] != params[:id]
            redirect_to login_path
        end

        # Pass helpful objects
        @courses = @logged_in_user.courses
        @assignments = @courses[0].assignments

        puts @assignments

        # @assignments = @courses[0].assignments

        # @grades = []
        # @max_grades = []
        # @weightings = []
        # @assignments.each do |assignment|
        #     grade = assignment.submissions.find_by(student_id: session[:id]).grade
        #     @max_grades.append(assignment.max_points)
        #     @weightings.append(assignment.weighting)
        #     if(grade == nil)
        #         @grades.append(0)
        #     else
        #         @grades.append(grade)
        #     end
        # end

        # @sum_grade = 0
        # @sum_weightings = 0
        # @grades.each_with_index do |grade,index|
        #     @sum_grade += @grades[index]/@max_grades[index]*@weightings[index]
        #     @sum_weightings += @weightings[index]
        # end

        # @current_grade = (@sum_grade/(@sum_weightings))*100
    end
end
