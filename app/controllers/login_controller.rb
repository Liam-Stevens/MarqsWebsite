class LoginController < ApplicationController
    # Don't check if logged in on the login page
    skip_before_action :redirect_to_root

    def index
        session[:ignore_redirect] = true

        # Set session ID if passed in parameters
        if params[:id] != nil
          session[:id] = params[:id]
          session[:logout] = false
        end

        # Redirect to page based on ID
        id = session[:id]
        if Student.exists?(student_id: id)
            session[:marker] = false
            session[:logged_in] = true
            session[:ignore_redirect] = false
            redirect_to student_path(id)

        elsif Marker.exists?(marker_id: id)
            session[:marker] = true
            session[:logged_in] = true
            session[:ignore_redirect] = false
            redirect_to marker_path(id)

        elsif session[:logout] == false
            @failure = "Not a valid ID"
        end
    end

    # Logs the user out and nukes the session
    def show
        session.clear
        session[:logout] = true
        session[:logged_in] = false
        redirect_to login_index_path
    end
end

