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
        if !@logged_in
            redirect_to root_path
        end
    end
end
