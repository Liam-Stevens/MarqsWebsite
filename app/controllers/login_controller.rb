class LoginController < ApplicationController
    # Don't check if logged in on the home page
    skip_before_action :redirect_to_root

    def index
        # Set session ID if passed in parameters
        if params[:id] != nil
            session[:id] = params[:id]
        end

        # Redirect to page based on ID
        id = session[:id]
        if Student.exists?(student_id: id)
            redirect_to student_path(id)

        elsif Marker.exists?(marker_id: id)
            redirect_to marker_path(id)

        # Otherwise indicate not found
        else
            session.clear
            @failure = "Invalid ID entered"
        end
    end

    # 'Logout' and redirect to home page
    def show
        session.clear
        redirect_to root_path
    end
end

