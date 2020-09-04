class StudentsController < ApplicationController
    def show
        # Redirect for wrong URI
        if session[:id] != params[:id]
            redirect_to login_path
        end

        # Pass helpful objects
        @courses = @logged_in_user.courses
        @assignments = @courses[0].assignments
    end
end
