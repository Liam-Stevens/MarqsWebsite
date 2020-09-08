class StudentsController < ApplicationController
    def show
        # Redirect for wrong URI
        if session[:id] != params[:id]
            redirect_to login_path
        end

        # Pass list of courses
        @courses = @logged_in_user.courses
    end
end
