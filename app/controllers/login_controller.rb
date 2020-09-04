class LoginController < ApplicationController
    # Don't check if logged in on the login page
    skip_before_action :redirect_to_root

    def index
        # Set session ID if passed in parameters
        if params[:id] != nil
          session[:id] = params[:id]
          session[:logout] = false
        end

        # Redirect to page based on ID
        id = session[:id]
        if Student.exists?(student_id: id)
            session[:marker] = false
            redirect_to student_path(id)

        elsif Marker.exists?(marker_id: id)
            session[:marker] = true
            redirect_to marker_path(id)

        elsif session[:logout] == false
            @failure = "Not a valid ID"
        end
    end

    # Logs the user out and nukes the session
    def show
        session.clear
        session[:logout] = true
        redirect_to root_path
    end
end

